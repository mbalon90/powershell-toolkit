<# .DESCRIPTION
Shows testing api #>
function API_Test {
    $response = Invoke-RestMethod https://jsonplaceholder.typicode.com/users

    $response[0].name
    $response[0].email
}
