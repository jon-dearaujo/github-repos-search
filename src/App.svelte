<script>
	const GITHUB_REPOS_SEARCH_URL = 'https://api.github.com/search/repositories?q='

	const debounce = (milliseconds) => {
		return new Promise((resolve, reject)=> {
			if (debounceId) {
				clearTimeout(debounceId)
			}
			debounceId = setTimeout(()=> {
				debounceId = null
				resolve()
			}, milliseconds)
		});	
	}
	
	const fetchGithubRepos = (searchTerm) => {
		return debounce(500)
			.then(() => {
				return fetch(GITHUB_REPOS_SEARCH_URL + searchTerm)
				.then(r => {
					return r.json()
				})
			})
	}

	$: reposPromise = searchTerm ?
		fetchGithubRepos(searchTerm) :
		Promise.resolve({items: []})
	
	let searchTerm = ''
	let debounceId = null
</script>
<style>
	h1 {
		max-width: 100%;
		margin: 50px auto;
		text-align: center;
	}
	div.input-container {
		max-width: 500px;
		margin: 0 auto;
	}
	
	div input {
		width: 100%;
	}
	
	p.searching-hint {
		width: 80%;
		text-align: center;
		margin: 0 auto;
		word-wrap: break-word;
	}
	
	p.empty-result {
		width: 80%;
		text-align: center;
		margin: 0 auto;
		word-wrap: break-word;
	}

	ul {
		list-style-type: none;
		width: 95%;
		margin: 20px auto;
		padding: 0;
		word-wrap: break-word;
	}
	
	ul li {
		padding: 5px;
	}
	
	ul li:nth-child(even) {
		background: lightgrey;
	}
</style>

<h1>Github Repos search</h1>

<div class="input-container">
	<input type="text" placeholder="Start typing" bind:value={searchTerm}/>
</div>

{#await reposPromise}
	<p class="searching-hint">searching by: {searchTerm}...</p>
{:then response}
	{#if response.total_count > 0}
		<ul>
			{#each response.items as repo}
				<li>
					<a href="{repo.html_url}" target="_blank">
						{repo.name}
					</a> by
					<a href="{repo.owner.html_url}" target="_blank">
						{repo.owner.login}
					</a>
				</li>
			{/each}
		</ul>
	{:else if searchTerm}
			<p class="empty-result">{searchTerm} has no results @ Github</p>
	{/if}
{:catch err}
	<p class="error">Something went wrong: {err}</p>
{/await}