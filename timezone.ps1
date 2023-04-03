$time=[System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId( (get-date "01/01/1970" ), 'Central Standard Time')
$time.AddSeconds(1597728285)
#[System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId( $time,'North Asia East Standard Time')
#[System.TimeZoneInfo]::GetSystemTimeZones( ) | select id

