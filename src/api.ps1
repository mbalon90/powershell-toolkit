<#API Testing playgroud.#>

<# .DESCRIPTION
Returns testing API #>
function Get-APITest {
    $response = Invoke-RestMethod https://jsonplaceholder.typicode.com/users

    $response[0].name
    $response[0].email
}
