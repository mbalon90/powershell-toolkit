<# .DESCRIPTION
Shows testing api #>
function API {
    Invoke-RestMethod https://jsonplaceholder.typicode.com/users
}