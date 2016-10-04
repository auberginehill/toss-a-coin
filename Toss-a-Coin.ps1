<#
Toss-a-Coin.ps1
#>


[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
      HelpMessage='Would you like to play an ancient game? Please add -Roman to play "Capita aut navia?" or -Greek for a regular round of chalkismos. To challenge the all-time best chalkismos-player, an additional parameter -Phryne could be used in combination with or without the -Greek parameter. To see the the rules of a game, a parameter -Help may be added.')]
    [Alias("Wait","Pause")]
    [ValidateRange(0,10000000000)]
	[int]$Delay = "3178", # in milliseconds: without the progresbar for instance, 750 for a slower pace and 178 for a reasonable responsive UX.
    [switch]$Greek,
    [switch]$Roman,
    [switch]$Phryne,
    [Alias("Text","Definition","Rules")]
    [switch]$Help,
    [switch]$Audio
)




Begin {


    # Use Get-Random to create a random array of one object plus define some other common variables
    $delay_notify_threshold = 15000 # in milliseconds (1 minute = 60000 milliseconds)
    $random_1d2 = Get-Random -Count 1 -InputObject (1..2)
    $random_1d100 = Get-Random -Count 1 -InputObject (1..100)
    $empty_line = ""
    $help_text_coin_toss = "It is not always easy to decide what is heads and tails on a given coin. Numismatics defines the obverse and reverse of a coin rather than heads and tails. The obverse (principal side) of a coin typically features a symbol intended to be evocative of stately power, such as the head of a monarch or well-known state representative. In the case of coins that do not have royalty or state representatives on them, the side that features the name of the country is usually considered to be the obverse. Source: [https://www.random.org/coins/]"
    $help_text_chalkismos = "The idea is to 'catch' or 'lock' the wildly spinning coin under the tip of a straight finger. Additionally it may be agreed upon that if any part of the coin extends under the first joint after the attempt, the attempt is considerd to be disqualified. Also it may be agreed upon that the remaing four fingertips of the primary hand must be placed on the table before an attempt to catch the coin is made."
    $definition_coin_toss = "In coin flipping (or coin tossing) an outcome is pronounced by each participant before a correct answer is revealed to the question, which side of a coin is facing upwards after the said coin has been tossed in the air. An ideal coin toss includes as many rotations around the coin's centre axel as possible (while the coin is still in the air)."
    $definition_capita_aut_navia = "In coin flipping (or coin tossing) an outcome is pronounced by each participant before a correct answer is revealed to the question, which side of a coin is facing upwards after the said coin has been tossed in the air. An ideal coin toss includes as many rotations around the coin's centre axel as possible (while the coin is still in the air). Linguistically oriented participants might call the obverse 'caput', if there's a single item depicted on the coin's obverse side, and 'capita' in case two or more similar items are depicted on the coin's obverse. Historically oriented participants might call the obverse 'capita' despite what is being depicted on it. The reverse is usually always called 'navia', but if so agreed upon, perhaps also one of the more linguistically correct forms may be accepted as an alternative name to the traditional reverse side name of 'navia'. Please see the History section (inside the source code) for further debate on this subject."
    $definition_chalkismos = "After a player has set a coin spinning on the table and while the coin still spins freely with reasonably good amount of spin around its center axel, the player tries to stop it with an extended straight index finger without the coin bouncing away."




    # Function used to convert numerical wait times to text
    function Get-TimeDifference {
        param ($wait_time)

        If ($wait_time.Days -ge 2) {
            $time_text = [string]$wait_time.Days + ' days ' + $wait_time.Hours + ' h ' + $wait_time.Minutes + ' min'
        } ElseIf ($wait_time.Days -gt 0) {
            $time_text = [string]$wait_time.Days + ' day ' + $wait_time.Hours + ' h ' + $wait_time.Minutes + ' min'
        } ElseIf ($wait_time.Hours -gt 0) {
            $time_text = [string]$wait_time.Hours + ' h ' + $wait_time.Minutes + ' min'
        } ElseIf ($wait_time.Minutes -gt 0) {
            $time_text = [string]$wait_time.Minutes + ' min ' + $wait_time.Seconds + ' sec'
        } ElseIf ($wait_time.Seconds -gt 0) {
            $time_text = [string]$wait_time.Seconds + ' sec'
        } Else {
            $time_text = [string]''
        } # else (if)

            If ($time_text.Contains(" 0 h")) {
                $time_text = $time_text.Replace(" 0 h","")
                } If ($time_text.Contains(" 0 min")) {
                    $time_text = $time_text.Replace(" 0 min","")
                    } If ($time_text.Contains(" 0 sec")) {
                    $time_text = $time_text.Replace(" 0 sec","")
            } # if ($time_text: first)

    $time_text

    } # function


} # begin




Process {


    If ((-not $Greek) -and (-not $Phryne) -and (-not $Roman)) {

        # Specify the coin flip rules - Regular
        $header = "Heads or Tails?"
        $coline = "---------------"
        $definition = $definition_coin_toss
        $help_text = $help_text_coin_toss

        If ($random_1d2 -eq 1) { $result = "Heads" } ElseIf ($random_1d2 -eq 2) { $result = "Tails" } Else { Write-Verbose "The coin landed on its edge." -verbose
        Write-Verbose "How thick should a coin be to have a 1/3 chance of landing on edge?" } # http://www.seas.harvard.edu/softmat/downloads/2011-10.pdf



    } ElseIf ((-not $Greek) -and (-not $Phryne) -and ($Roman)) {

        # Specify the coin flip rules - Roman
        $header = "Capita aut navia?"
        $coline = "-----------------"
        $definition = $definition_capita_aut_navia
        $help_text = $help_text_coin_toss

        If ($random_1d2 -eq 1) { $result = "Capita" } ElseIf ($random_1d2 -eq 2) { $result = "Navia" } Else { Write-Verbose "Nec capita nec navia." -verbose }


    } ElseIf (($Greek) -and (-not $Phryne) -and (-not $Roman)) {

        # Specify the coin flip rules - Greek χαλκισμός
        $header = "Chalkismos"
        $coline = "----------"
        $definition = $definition_chalkismos
        $help_text = $help_text_chalkismos

        If ($random_1d100 -ge 51) { $result = "Success" } ElseIf ($random_1d100 -ge 1) { $result = "Fail" } ElseIf ($random_1d100 -eq 0) { $result = "Disqualified" } Else { Write-Verbose "The coin did not rotate." -verbose }


    } ElseIf (($Greek) -and ($Phryne) -and (-not $Roman)) {
        $header = "Chalkismos against Phryne"
        $coline = "-------------------------"
        $definition = $definition_chalkismos
        $help_text = $help_text_chalkismos

        # Specify the coin flip rules - Greek χαλκισμός against Phryne 1
        If ($random_1d100 -ge 3) { $result = "Success" } ElseIf ($random_1d100 -ge 1) { $result = "Fail" } ElseIf ($random_1d100 -eq 0) { $result = "Disqualified" } Else { Write-Verbose "The coin did not rotate." -verbose }


    } ElseIf ((-not $Greek) -and ($Phryne) -and (-not $Roman)) {
        $header = "Chalkismos against Phryne"
        $coline = "-------------------------"
        $definition = $definition_chalkismos
        $help_text = $help_text_chalkismos

        # Specify the coin flip rules - Greek χαλκισμός against Phryne 2
        If ($random_1d100 -ge 3) { $result = "Success" } ElseIf ($random_1d100 -ge 1) { $result = "Fail" } ElseIf ($random_1d100 -eq 0) { $result = "Disqualified" } Else { Write-Verbose "The coin did not rotate." -verbose }


    } ElseIf ((-not $Greek) -and ($Phryne) -and ($Roman)) {

        # Specify the coin flip rules - Roman against Phryne
        $empty_line | Out-String
        Write-Verbose "Phryne doesn't know the 'Capita aut navia' game." -verbose
        $empty_line | Out-String
        Exit

    } ElseIf (($Greek) -and ($Roman)) {

        # Specify the coin flip rules - Greek and Roman
        $empty_line | Out-String
        Write-Verbose "Please choose, which game to play (either 'Capita aut navia?' or 'Chalkismos') by removing either the -Greek or -Roman parameter from the command." -verbose
        $empty_line | Out-String
        $duo_text = "These two games cannot effectively be played at the same time with one coin."
        Write-Output $duo_text
        $empty_line | Out-String
        Exit

    } Else {

       $continue = $true

    } # else (if)




    # Define the audio results
    If (($result -eq "Heads") -or ($result -eq "Capita") -or ($result -eq "Success")) {
        $audio_result = ([char]7, [char]7)
    } ElseIf (($result -eq "Tails") -or ($result -eq "Navia") -or ($result -eq "Fail")) {
        $audio_result = ([char]7, [char]7, [char]7, [char]7, [char]7)
    } Else {
       $continue = $true
    } # else




} # Process




End {


    # Clear the screen (number 1) and display the help if set to do so
    If (-not $Help) {

        cls
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $header | Out-String
        $coline | Out-String

    } ElseIf ($Help) {

        cls
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $header | Out-String
        $coline | Out-String

        Write-Output $definition
        $empty_line | Out-String
        Write-Output $help_text
        $empty_line | Out-String

    } Else {

       $continue = $true

    } # else (if)




        # Notify the user, if the delay is over the delay_notify_threshold
        If ($Delay -gt $delay_notify_threshold) {

                    # Calculate common variables for the delay_notify_threshold
                    $result_ready = [DateTime]::Now.AddMilliseconds($Delay)
                #   $result_ready = Get-Date ((Get-Date).AddMilliseconds($Delay))
                    $result_ready_date = $result_ready.ToShortDateString()
                    $result_ready_time = Get-Date ($result_ready) -Format HH:mm:ss
                    $result_wait_time = Get-TimeDifference((New-TimeSpan -seconds ($Delay/1000)))

            Write-Verbose "A total wait time of $result_wait_time initiated." -verbose
            $empty_line | Out-String
            "The result will be given on $result_ready_date at $result_ready_time o'clock. To set this countdown to zero (and to get the result within the next second), after selecting this PowerShell window as the active window (by for instance clicking on the window header) please press the letter q on the keyboard or tap the [Esc] key twice. To stop this countdown and to close this script immediately without showing any results, please use the Ctrl + C key combination after selecting this PowerShell window as the active window." | Out-String

        } Else {
            $continue = $true
        } # else (if)




    # Determine if there's a real need for the progress bar and the timer and display in console accordingly
    $wait_time_total = ([DateTime]::Now.AddMilliseconds($Delay)) - (Get-Date)
    $total_seconds = [int]$wait_time_total.TotalSeconds


    If ($total_seconds -lt 1) {

        $a_progressbar_will_be_shown = $false
        Start-Sleep -m $Delay
        $continue = $true

    } Else {

        $a_progressbar_will_be_shown = $true
        Start-Sleep -m $wait_time_total.Milliseconds

        # Set the progress bar variables
        $countdown_id       = 1 # For using more than one progress bar
        $countdown_status   = " "


        # Start the progress bar and a timer
        $timer = [System.Diagnostics.Stopwatch]::StartNew()
        Write-Progress -Id $countdown_id -Activity $header -Status $countdown_status -CurrentOperation "Time Elapsed: 00:00:00" -PercentComplete 0
        Write-Host "`rResult:                              $total_seconds              " -NoNewline


        # Update the progress bar and the timer once in a second                              # Credit: Martin Pugh: "Start-Countdown"
        ForEach ($step in (1..$total_seconds)) {

            Start-Sleep -Seconds 1
            $time_elapsed = $timer.Elapsed


            # Update the progress bar                                                         # Credit: Jeff: "Powershell show elapsed time"
            Write-Progress -Id $countdown_id -Activity $header -Status $countdown_status -CurrentOperation "$([string]::Format('Time Elapsed: {0:d2}:{1:d2}:{2:d2}', $time_elapsed.Hours, $time_elapsed.Minutes, $time_elapsed.Seconds))" -PercentComplete (($step / $total_seconds) * 100)


            # Update the timer                                                                # Credit: Jeff: "Powershell show elapsed time"
            If ($($total_seconds - $step) -gt 0) {
                Write-Host $([string]::Format("`rResult:                              $($total_seconds - $step)              ")) -NoNewline
            } Else {
                Write-Host $([string]::Format("`rResult:                                            ")) -NoNewline
            } # else


            # Specify [Esc] and [q] as the Cancel-key                                         # Credit: Jeff: "Powershell show elapsed time"
            If ($Host.UI.RawUI.KeyAvailable -and ("q" -eq $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho").Character)) {
                Write-Host " ...Stopping the Count Down and the Timer...";
                Break;
            } ElseIf ($Host.UI.RawUI.KeyAvailable -and (([char]27) -eq $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho").Character)) {
                Write-Host " ...Stopping the Count Down and the Timer..."; Break;
            } Else {
                $continue = $true
            } # else

        } # foreach


        # Close the progress bar
        Write-Progress -Id 1 -Activity $header -Status $countdown_status -PercentComplete 100 -Completed
        $empty_line | Out-String


    } # else (progress bar)




    # Clear the screen (number 2) and display the results
    $print = "Result:                              $result"


        If (-not $Help) {

            cls
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $header | Out-String
            $coline | Out-String


                If ($Delay -gt $delay_notify_threshold) {
                    $empty_line | Out-String
                    $empty_line | Out-String
                    $empty_line | Out-String
                    $empty_line | Out-String
                } Else {
                    $continue = $true
                } # else (if)


            Write-Output $print

                If ($Audio) {
                    Write-Host $audio_result | Out-Null
                } Else {
                    $continue = $true
                } # else (if)

            Return $empty_line


        } ElseIf ($Help) {

            cls
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $header | Out-String
            $coline | Out-String

            Write-Output $definition
            $empty_line | Out-String
            Write-Output $help_text
            $empty_line | Out-String


                If ($Delay -gt $delay_notify_threshold) {
                    $empty_line | Out-String
                    $empty_line | Out-String
                    $empty_line | Out-String
                    $empty_line | Out-String
                } Else {
                    $continue = $true
                } # else (if)

            Write-Output $print

                If ($Audio) {
                    Write-Host $audio_result | Out-Null
                } Else {
                    $continue = $true
                } # else (if)

            Return $empty_line


        } Else {

            $continue = $true

        } # else (if)


} # End




# [End of Line]


<#

  _    _ _     _
 | |  | (_)   | |
 | |__| |_ ___| |_ ___  _ __ _   _
 |  __  | / __| __/ _ \| '__| | | |
 | |  | | \__ \ || (_) | |  | |_| |
 |_|  |_|_|___/\__\___/|_|   \__, |
                              __/ |
                             |___/




 __   __      __
 \ \ / /      \ \
  \ v / __  __ \ \   _  ___  ____ _   _  ___   ____
   > < /  \/ /  > \ | |/ / |/  ._) | | |/ _ \ / ___)
  / ^ ( ()  <  / ^ \|   <| ( () )| |_| | (_) ( (__
 /_/ \_\__/\_\/_/ \_\_|\_\\_)__/ | ._,_|\___/ \__ \
                                 | |            _) )
                                 |_|           (__/

Write-Verbose "Χαλκισμός (Chalkismos)" -verbose

"In the game called χαλκισμός (chalkismos) the player had to spin a coin on the
table and then stop it with an extended index finger without the coin falling over.
The date of invention is not known but Ἰούλιος Πολυδεύκης Ναυκρατίτης (a.k.a.
Julius Pollux) reports that the greatest master of the game was Φρύνη (a.k.a.
Μνησαρέτη a.k.a. Phryne, born c. 371 BC), the famous courtesan (ἑταίρα) in the
second half of 4th c. BC. [1]


                'Καὶ μὴν καὶ ἄλλαι παιδιαὶ αἵδε πaρεoικυῖαι τῷ σχήματι τῆς λέξεως,
                χαλκισμὸς, ἱμαντελιγμὸς, ἐφεδρισμὸς, ἐποστρακισμὸς, ἀσκωλιασμός.
                Ό μὲν χαλκισμὸς, ὀρθὸν νόμισμα ἔδει συντόνως περιστρέψαντας
                ἐπιστρεφόμενον ἐπιστῆσαι τῷ δακτύλω. ᾧ τρόπῳ μάλιστα τῆς παιδιᾶς
                ὑπερήδεσθαί φασι Φρύνην τἠν ἑταίραν.'


                Ἰούλιος Πολυδεύκης Ναυκρατίτης (2nd century AD)
                a.k.a. Julius Pollux:   'Ὀνομαστικόν' (Onomasticon): Vol. IX, 118.
                                        [a Greek thesaurus of terms] [2]



___________________________

[1]     Németh 2013, 55—56; Rowan 2009, 7; Melville-Jones 1993, no. 657;
        http://www.perseus.tufts.edu/hopper/morph?l=xalkismos&la=greek#lexicon — Χαλκισμός

[2]     Ἰούλιος Πολυδεύκης Ναυκρατίτης a.k.a. Julius Pollux: https://archive.org/details/onomasticon01polluoft — Ὀνομαστικόν' (Onomasticon): Vol. IX, 118. (Greek)
        https://archive.org/stream/onomasticon01polluoft/onomasticon01polluoft_djvu.txt — Full text of "Onomasticon"
        Julius Pollux: https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft.pdf — Onomasticon: Vol. VI-X, Color (Greek) (PDF, 17.1 MB)
        Julius Pollux: https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft_bw.pdf — Onomasticon: Vol. VI-X, BW (Greek) (PDF, 13.1 MB)
        https://openlibrary.org/works/OL10686184W/Onomasticon — Onomasticon (10 editions) By Julius Pollux






   _____            _ _                      _                       _      ___
  / ____|          (_) |                    | |                     (_)    |__ \
 | |     __ _ _ __  _| |_ __ _    __ _ _   _| |_   _ __   __ ___   ___  __ _  ) |
 | |    / _` | '_ \| | __/ _` |  / _` | | | | __| | '_ \ / _` \ \ / / |/ _` |/ /
 | |___| (_| | |_) | | || (_| | | (_| | |_| | |_  | | | | (_| |\ V /| | (_| |_|
  \_____\__,_| .__/|_|\__\__,_|  \__,_|\__,_|\__| |_| |_|\__,_| \_/ |_|\__,_(_)
             | |
             |_|

Write-Verbose "Capita aut navia?" -verbose

In antiquity within the Roman cultural sphere, the commonly used name for the game
of 'heads or tails' was 'capita aut navia' (heads or a ship), which, perhaps, could 
also be considered as the original ancestral name of the game of 'heads or tails'. 
The name might have derived from the early Roman Republic coinage that had the 
double-faced head of Ianus a.k.a. Janus on the obverse and the prow of a ship on the
reverse. Ianus was a deity considered by Romans to be the first king of Latium on 
the site of the city before its foundation and was believed to have two faces: to 
see what was going on in front and behind him; who knew the past and foresaw the 
future. The prow of a ship or a full ship would resemble the ship on which Saturnus
a.k.a. Saturn arrived to Ianiculum a.k.a. Janiculum after been expelled from the 
heavens by Iuppiter a.k.a. Jupiter a.k.a. Jove. The existence of such coins and the
aforementioned backstory is hinted by an anonomous author in a short work called 
'Origo Gentis Romanae' ("The Origins of the Roman People"), which was composed 
perhaps sometime in the fourth century AD, which used to be credited to the Roman
historian Sextus Aurelius Victor (c. AD 320–390), but currently is not assigned 
to any particular author, where Ianus is said to be the one that directly taught 
the ancient Romans how to work with bronze and how to put the money in a form of 
a coin. Furhermore it seems to be indicated that on those coins on one side would 
be the head of Ianus, the mentor himself, and on the other side the ship that had
brought Saturnus a.k.a. Saturn to Latium: [3]



                "Igitur Iano regnante apud indigenas rudes incultosque Saturnus 
                regno profugus, cum in Italiam devenisset, benigne exceptus 
                hospitio est ibique haud procul a Ianiculo arcem suo nomine 
                Saturniam constituit. Isque primus agriculturam edocuit ferosque 
                homines et rapto vivere assuetos ad compositam vitam eduxit, 
                secundum quod Vergilius in octavo sic ait: 


                            Haec loca indigenae Fauni Nymphaeque tenebant, 
                            Gensque virum truncis et duro robore nata, 
                            Quis neque mos neque cultus erat nec iungere tauros 
                            Aut componere opes norant aut parcere parto, 
                            Sed rami atque asper victu venatus alebat. [Aen. VIII.314-318]


                Omissoque Iano, qui nihil aliud quam ritum colendorum deorum 
                religionesque intulerat, se Saturno maluit annectere, qui vitam 
                moresque feris etiam tum mentibus insinuans ad communem utilitatem,
                ut supra diximus, disciplinam colendi ruris edocuit, ut quidem 
                indicant illi versus: 


                            Is genus indocile ac dispersum montibus altis 
                            Composuit legesque dedit Latiumque vocari 
                            Maluit. [Aen. VIII.321-323]


                Is tum etiam usum signandi aeris ac monetae in formam incutiendae
                ostendisse traditur, in quam ab una parte caput eius imprimeretur,
                altera navis, qua vectus illo erat. Unde hodieque aleatores posito
                nummo opertoque optionem collusoribus ponunt enuntiandi, quid putent
                subesse, caput, aut navem: quod nunc vulgo corrumpentes naviam 
                dicunt. Aedes quoque sub clivo Capitolino, in qua pecuniam conditam
                habebat, aerarium Saturni hodieque dicitur. Verum quia, ut supra 
                diximus, prior illuc Ianus advenerat, cum eos post obitum divinis 
                honoribus cumulandos censuissent, in sacris omnibus primum locum
                Iano detuleruat, usque eo, ut etiam, cum aliis diis sacrificium fit,
                dato ture in altaria, Ianus prior nominetur, cognomento quoque 
                addito Pater, secundum quod noster sic intulit: 


                            Hanc Ianus Pater, hanc Saturnus condidit arcem. [Aen. VIII.357]


                Ac subinde: Ianiculum huic, illi fuerat Saturnia nomen. [Aen. VIII.358] 


                Eique, eo quod mire praeteritorum memor, tum etiani futuri..."


                Author Unknown – Incerti Auctoris – Sextus Aurelius Victor (c. AD 320–390):
                'Origo Gentis Romanae' (The Origins of the Roman People) 3:1-7. [4]


Translation

Translated by: Kyle Haniszewski, Lindsay Karas, Kevin Koch, Emily Parobek, Colin Pratt, 
and Brian Serwicki; Thomas M. Banchich, Supervisor


                "Therefore, while Janus was reigning among unrefined and unpolished 
                natives, Saturnus, having fled his realm, was warmly received with 
                hospitality when he had arrived in Italy and there, not far from 
                the Janiculum, founded a stronghold with his own name, Saturnia. 
                And he first taught agriculture and introduced to a settled life 
                men savage and accustomed to live by plunder, in accordance with 
                which Virgil in Book VIII speaks thus: 


                            These spots native Fauns and Nymphs used to hold, 
                            And a race of men from trunks and rough wood born, 
                            Who knew neither tradition nor reverence nor how to yoke bulls 
                            Nor to lay away resources or to preserve a part of what had been obtained, 
                            But fed from the bough and fierce victim of the hunt. [Aen. VIII.314-318]


                And with Janus, who had introduced nothing other than the practice 
                of reverence of the gods and religious ceremonies, omitted, he 
                preferred to turn his attention to Saturnus, who, as we said above,
                introducing to minds even then savage a way of life and habits 
                conducive to the common good, taught the art of tending the field, 
                as, indeed, these verses demonstrate: 


                            He this race, restless and scattered in lofty mountains, 
                            Did unify and gave them laws and preferred it to be called 
                            Latium. [Aen. VIII.321-323]


                Then, too, he is said to have introduced the practice of marking 
                bronze and of striking coinage in a die in which from one his head 
                was imprinted, from the other the ship by which he had been borne 
                there. Whence even to this day gamblers, when a coin has been set 
                down and covered, lay as a wager to players the option of declaring 
                what they think is underneath, a head or a ship [navis], which now, 
                commonly adulterating, they pronounce shrudder [navia]. Also, the 
                building beneath the Capitoline slope in which he used to keep the 
                coinage which had been produced is to this day called Saturnus' 
                Treasury. In fact, because, as we said above, Janus had arrived 
                before him, when, after their deaths, they reckoned that these men 
                must be loaded with divine honors, in all religious ceremonies 
                they assigned first place to Janus, with the result that, even 
                when a sacrifice is made to other gods, when incense has been 
                offered at the altars, Janus is named first, with the cognomen 
                "Father" also added, in accordance with which our man did thus 
                produce: 


                            This base did Father Janus, this did Saturnus found. [Aen. VIII.357]


                And immediately thereafter: Janiculum was the name for the one, Saturnia for the other. [Aen. VIII.358] 


                And to him, because of a wondrous memory of things past as well 
                as of the future..."


                Author Unknown – Incerti Auctoris – Sextus Aurelius Victor 
                (c. AD 320–390): 'Origo Gentis Romanae' (The Origins of the 
                Roman People) 3:1-7. [5]


In the first book of 'Fasti' (The Festivals), which was dedicated to Germanicus 
(15 BC – AD 19, a.k.a. Germanicus Julius Caesar a.k.a. Nero Claudius Drusus or 
Tiberius Claudius Nero), the author, P. Ovidius Naso (43 BC – AD 18), 
a.k.a. Ovid) tells that while he had an encounter with Ianus, which was not just a 
simple real-life revelation of a god, but also a dialogue, too, with a god, Ianus 
enlightened the author on varying subjects, such as why and how did he have such 
distinctively shaped head with two faces, and then promptly proceeded to answear all 
the questions that Ovidius was eager to ask. The following is an exerpt of the 
dialogue between Ovidius and Ianus as per recorded by Ovidius, in which, for example,
the expulsion of Saturnus from the celestial realms is reflected, and a godly answear 
to the question "Why is the figure of a ship stamped on one side of the copper coin, 
and a two-headed figure on the other?" is revealed:


                Ovidius: "Quid volt palma sibi rugosaque carica," dixi, "et data sub 
                niveo candida mella cado?" 


                Ianus: "Omen," ait, "causa est, ut res sapor ille sequatur et 
                peragat coeptum dulcis ut annus iter." 


                Ovidius: "Dulcia cur dentur, video, stipis adice causam, pars mihi 
                de festo ne labet ulla tuo." 


                Risit et 


                Ianus: "O quam te fallunt tua saecula," dixit, "qui stipe mel sumpta
                dulcius esse putes [putas]! vix ego Saturno quemquam regnante 
                videbam, cuius non animo dulcia lucra forent. Tempore crevit amor, 
                qui nunc est summus, habendi vix ultra, quo iam progrediatur, habet. 
                Pluris opes nunc sunt, quam prisci temporis annis, dum populus 
                pauper, dum nova Roma fuit, dum casa Martigenam capiebat parva 
                Quirinum, et dabat exiguum fluminis ulva torum. Iuppiter angusta 
                vix totus stabat in aede, inque Iovis dextra fictile fulmen erat. 
                Frondibus ornabant quae nunc Capitolia gemmis, pascebatque suas ipse 
                senator oves; nec pudor in stipula placidam cepisse quietera 
                [quietem] et faenum capiti supposuisse [subposuisse] fuit. Iura dabat 
                populis posito modo praetor aratro, et levis argenti lammina crimen 
                erat. At postquam fortuna loci caput extulit huius, et tetigit summos 
                [summo] vertice Roma deos, creverunt et opes et opum furiosa cupido, 
                et, cum possideant plurima, plura petunt. Quaerere, ut absumant, 
                absumpta requirere certant, atque ipsae vitiis sunt alimenta vices. 
                Sic quibus intumuit suffusa venter ab unda, quo plus sunt potae, 
                plus sitiuntur aquae. In pretio pretium nunc est: dat census honores, 
                census amicitias: pauper ubique iacet.


                Tu tamen auspicium si sit stipis utile, quaeris, curque iuvent 
                vestras aera vetusta manus? Aera dabant olim, melius nunc omen in 
                auro est, victaque concessit prisca moneta novae, nos quoque templa
                iuvant, quamvis antiqua probemus, aurea: maiestas convenit ista 
                [ipsa] deo. Laudamus veteres, sed nostris utimur annis: mos tamen 
                est aeque dignus uterque coli." 


                Finierat monitus. placidis ita rursus, ut ante, clavigerum verbis
                adloquor ipse deum: 


                Ovidius: "Multa quidem didici: sed cur navalis in aere altera 
                signata est, altera forma biceps?" 


                Ianus: "Noscere me duplici posses sub imagine," dixit, "ni vetus 
                ipsa dies extenuasset opus, causa ratis superest: Tuscum rate venit
                in [ad] amnem ante pererrato falcifer orbe deus. hac ego Saturnum 
                memini tellure receptum caelitibus regnis a Iove pulsus erat. Inde 
                diu genti mansit Saturnia nomen; dicta quoque est Latium terra, 
                latente deo. At bona posteritas puppem formavit in aere, hospitis 
                adventum testificata dei. Ipse solum colui, cuius placidissima 
                laevum radit harenosi Thybridis unda latus. Hic, ubi nunc Roma est, 
                incaedua silva virebat, tantaque res paucis pascua bubus erat. Arx 
                mea collis erat, quem volgus [volgo] nomine nostro nuncupat, haec 
                aetas Ianiculumque vocat. Tunc ego regnabam, patiens cum terra 
                deorum esset, et humanis numina mixta locis. Nondum Iustitiam 
                facinus mortale fugarat (ultima de superis illa reliquit humum), 
                proque metu populum sine vi pudor ipse regebat; nullus erat iustis 
                reddere iura labor, nil mihi cum bello: pacem postesque tuebar et"
                clavem ostendens "haec," ait, "arma gero." 


                Presserat ora deus.


                (Ov. Fast. 1, 185—255): P. Ovidius Naso (43 BC – AD 18), a.k.a. 
                Ovid): 'Fasti' (The Festivals) 1:235—255 [6]


Translation


                Ovidius: "What mean the gifts of dates and wrinkled figs," I said, 
                "and honey glistering in snow-white jar?" 


                Ianus: "It is for the sake of the omen," said he, "that the event 
                may answer to the flavour, and that the whole course of the year may 
                be sweet, like its beginning." 


                Ovidius: "I see," said I, "why sweets are given. But tell me, too, 
                the reason for the gift of cash, that I may be sure of every point 
                in thy festival." 


                The god laughed, and 


                Ianus: "Oh," quoth he, "how little you know about the age you have 
                in if you fancy that honey is sweeter than cash in hand! Why, even 
                in Saturn's reign I hardly saw a soul who did not in his heart find 
                lucre sweet. As time went on the love of pelf grew, till now it is 
                at its height and scarcely can go farther. Wealth is more valued now 
                than in the years of old, when the people were poor, when Rome was 
                new, when a small hut sufficed to lodge Quirinus, son of Mars, and 
                the river sedge supplied a scanty bedding. Jupiter had hardly room to 
                stand upright in his cramped shrine, and in his right hand was a 
                thunderbolt of clay. They decked with leaves the Capitol, which now 
                they deck with gems, and the senator himself fed his own sheep. It 
                was no shame to take one's peaceful rest on straw and to pillow the 
                head on hay. The praetor put aside the plough to judge the people, 
                and to own a light piece of silver plate was a crime. But ever since 
                the Fortune of this place has raised her head on high, and Rome with 
                her crest has touched the topmost gods, riches have grown and with 
                them the frantic lust of wealth, and they who have the most 
                possessions still crave for more. They strive to gain that they may 
                waste, and then to repair their wasted fortunes, and thus they feed 
                their vices by ringing the changes on them. So he whose belly swells 
                with dropsy, the more he drinks, the thirstier he grows. Nowadays 
                nothing but money counts: fortune brings honours, friendships; the 
                poor man everywhere lies low. 


                And still you ask me. What's the use of omens drawn from cash, and 
                why do ancient coppers tickle your palms! In the olden time the 
                gifts were coppers, but now gold gives a better omen, and the 
                old-fashioned coin has been vanquished and made way for the new. 
                We, too, are tickled by golden temples, though we approve of the 
                ancient ones: such majesty befits a god. We praise the past, but use
                the present years; yet are both customs worthy to be kept." 


                He closed his admonitions but again in calm speech, as before, I 
                addressed the god who bears the key: 


                Ovidius: "I have learned much indeed; but why is the figure of a 
                ship stamped on one side of the copper coin, and a two-headed figure 
                on the other?" 


                Ianus: "Under the double image," said he, "you might have recognized 
                myself, if the long lapse of time had not worn the type away. Now for 
                the reason of the ship. In a ship the sickle-bearing god came to the 
                Tuscan river after wandering over the world. I remember how Saturn 
                was received in this land: he had been driven by Jupiter from the 
                celestial realms. From that time the folk long retained the name of 
                Saturnian, and the country, too, was called Latium from the hiding 
                (latente) of the god. But a pious posterity inscribed a ship on the 
                copper money to commemorate the coming of the stranger god. Myself 
                inhabited the ground whose left side (is lapped by) sandy Tiber's 
                glassy wave. Here, where now is Rome, green forest stood unfelled, 
                and all this mighty region was but a pasture for a few kine. My 
                castle was the hill which common folk call by my name, and which 
                this present age doth dub Janiculum. I reigned in days when earth 
                could bear with gods, and divinities moved freely in the abodes of 
                men. The sin of mortals had not yet put Justice to flight (she was 
                the last of the celestials to forsake the earth): honour's self, not
                fear, ruled the people without appeal to force: toil there was none 
                to expound the right to righteous men. I had naught to do with war: 
                guardian was I of peace and doorways, and these," quoth he, showing 
                the key, "these be the arms I bear." 


                The god now closed his lips.


                (Ov. Fast. 1, 185—255): P. Ovidius Naso (43 BC – AD 18), a.k.a. Ovid): 
                'Fasti' (The Festivals) 1:235—255 [6]


It cannot get more authorative than that, you heard the answear to the question 
"Why is the figure of a ship stamped on one side of the copper coin, and a two-headed 
figure on the other?" straight from Ianus himself, as narrated by Ovidius. 
Apparently a fourth–fifth century Christian (Roman) writer and churchman Pontius 
Paulinus Nolanus (c. AD 353—431, a.k.a. Pontius Meropius Anicius Paulinus a.k.a. 
Paulinus of Nola (who, about after AD 409, was chosen to be the Bishop of 
Nola)) had heard of this story as well, since he does describe matters in a similar 
way, when he discusses briefly why some things are called as they are called and 
with a striking similarity with Ovidius' view desciribes how the 'capita' became 
to signify one side of a coin and 'navia' the other side of the coin in this brief 
excerpt from one of his poems, which were mostly written in Nola, Campania, where 
each year after AD 395 he would write a poem in honor of the saint (St.) Felix, to 
whom he credited his conversion to and who actually was also buried in Nola: [7]


                "Nomen habet certe quod nec ratione probetur. Sacra Ioui faciunt 
                et 'Iuppiter Optime' dicunt huncque rogant, et 'Iane Pater' primo 
                ordine ponunt. Rex fuit hic Ianus proprio qui nomine fecit 
                Ianiculum, prudens homo, qui cum multa futura posset respicere, 
                (et) duplici hunc pinxere figura et Ianum geminum veteres dixere 
                Latini. Hic quia navigio Ausonias aduenit ad oras, nummus huic 
                primum tali est excussus honore, ut pars una caput, pars sculperet 
                altera navem; cuius nunc memores quaecumque nomismata signant, ex 
                veteri facto 'capita' haec 'et navia' dicunt."


                Pontius Paulinus Nolanus (c. AD 353–431) a.k.a. Pontius Meropius 
                Anicius Paulinus a.k.a. Paulinus of Nola: 'Carmina' (Carmen, Poëm, 
                Poem) 32:65—77. [8]


In the game of 'capita aut navia' itself, a play of the Roman youth or the 
"gamblers" aleatores mentioned above, a piece of money was thrown up to see whether
the figure-side a.k.a. obverse (the double-faced head of Ianus) or the reverse-side 
(a ship) will fall uppermost. The heads of Ianus and the prora were first used in 
the Roman coinage around 225 BC, which might designate the earliest date for the 
invention of the game in its current form, though without any doubt children have 
been flinging coins before that with varying game-play modes. Children may, indeed, 
have something to do with the very name of the game itself, too, since the word 
'navia' actually doesn't seem to be a proper Latin word at all: [9]


                caput, capitis  = 'a head'

                navis, navis    = 'a ship'

                navia, naviae   = 'a ship' — A corruption of navis, 'a ship'; used 
                                for instance in the proverb 'aut caputa aut naviam' 
                                [sic] instead of the more linguistically correct 
                                forms of 'aut caput aut navem' (singular acc) or 
                                'aut capita aut naves' (plural acc) [10]


One of the earliest times that this linguistical atrocity rotting the very essence, 
how and in which way things are named, was in the fourth century in the third chapter 
of 'Origo Gentis Romanae' ("The Origins of the Roman People"), which used to be 
credited to the Roman historian Sextus Aurelius Victor (c. AD 320–390), but 
currently is not assigned to any particular author, where this unknown author pointed
 out, that it would be better to use 'navem' instead of the "vulgar" or "corrupted" 
 word of 'navia'...


                "Unde hodieque aleatores posito nummo opertoque optionem collusoribus
                ponunt enuntiandi, quid putent subesse: caput, aut navem; quod nunc 
                vulgo corrumpentes naviam dicunt."


                Author Unknown – Incerti Auctoris – Sextus Aurelius Victor (c. AD 320–390):
                'Origo Gentis Romanae' (The Origins of the Roman People) 3:5. [11]


Translation

                "That is why even today gamblers, after a coin has been put down and 
                hidden, announce to their fellow gambler the choice, which one could 
                be underneath: head or ship; which now the common people say 
                corruptly 'navia'."


                Author Unknown – Incerti Auctoris – Sextus Aurelius Victor (c. AD 320–390):
                'Origo Gentis Romanae' (The Origins of the Roman People) 3:5. [11]


It must be noted, though, that since the fourth century the vulgarity of the 'navia' 
term has faded gradually, and its usage has became more widely accepted (O tempore, 
o mores...), but still, one can only wonder, how this anomality came into being and 
furhermore, how it even surpassed the 'linguistically correct' version and flourished 
throughout the centuries despite what was being depicted on the coins.

'Navia', however, did become so enrooted in the cultural landscape of Rome, that even
the early Church Fathers used it occasionally without a blink of an eye instead of 
the more correct word forms, as demonstrated above by the Bishop of Nola. The word 
'navia' is used in a more condemning manner by Aurelius Augustinus Hipponensis a.k.a. 
Augustine of Hippo (AD 354–430) in 'De Anima et Eius Origine, Liber IV' (A Treatise on 
the Soul and Its Origin, Book IV) Chapter 20 [XIV] called 'Quisnam sit interior 
videamus: utrum anima, an spiritus, an utrumque' (What kind of an inner man do we see: 
the soul, the spirit or both) where, while trying to refute a worldview, in which a man 
consists of three parts (the outer, the inner and the inmost), Aurelius Augustinus 
Hipponensis uses 'caput et navia' as a direct reference point (


                "sicut in nummo dicitur 'caput et navia'"


                Aurelius Augustinus Hipponensis (AD 354–430, a.k.a. Augustine of 
                Hippo ): 'De Anima et Eius Origine, Liber IV' (A Treatise on the Soul 
                and Its Origin, Book IV) Chapter 20 [XIV] [12]


) in an hypothetical example of how the three-part-man could be "refashioned after 
the image of god" by "receiveing god's image" or by "being renewed in the knowledge 
of god". Though Aurelius Augustinus Hipponensis had adhered to Manichaeism and also 
for some time had favoured the scepticism of the New Academy and had converted to 
Catholicism in AD 387 and had became the Bishop of Hippo in AD 395 and had held the 
position for about 23 years at the time of the publication of the 'navia'-text, 
which was written towards the end of AD 419, he was not, by any means, an uneducated 
person, but still he used the same 'incorrect' word as the "gamblers" aleatores on 
the street, when addressing to the sides of a coin, which, by judging only by the 
choise of words, according to Cicero, would place him in the same category as the 
adulterers and all the other unclean and shameless citizens. [13]


                "(Postremum autem genus...) In his gregibus omnes aleatores, omnes 
                adulteri, omnes impuri impudicique versantur."


                (Cic. Catil. 2.10.22–23) Marcus Tullius Cicero a.k.a. Κικέρων,
                (106–43 BC): 'M. Tulli Ciceronis in L. Catilinam orationes quattuor': 
                In L. Catilinam Oratio Secunda Habita Ad Populum 10.22–23 
                (The Second oration of Marcus Tullius Cicero against 
                Lucius Catilina, Addressed to the People. 10.22–23) [14]


Translation

                "(The last class...) In these crowds are all the gamblers, all the 
                adulterers, all the unclean and shameless citizens."


                (Cic. Catil. 2.10.22–23) Marcus Tullius Cicero a.k.a. Κικέρων,
                (106–43 BC): 'M. Tulli Ciceronis in L. Catilinam orationes quattuor': 
                In L. Catilinam Oratio Secunda Habita Ad Populum 10.22–23 
                (The Second oration of Marcus Tullius Cicero against 
                Lucius Catilina, Addressed to the People. 10.22–23) [14]


A fifth century Roman author Macrobius Ambrosius Theodosius records perhaps the 
clearest example of this ancient version of the 'heads' or 'tails' game in the 
the seventh chapter of the first book in the seven book Saturnalia series. It 
truly is striking, how the name of the game had persisted throughout the centuries
in spite of the fact that the design of the Roman coinage had changed radically 
by Macrobius' period. [15]


                "Regionem istam, quae nunc vocatur Italia, regno Ianus optinuit, 
                qui, ut Hyginus Protarchum Trallianum secutus tradit, cum Camese 
                aeque indigena terram hanc ita participata potentia possidebant, 
                ut regio Camesene, oppidum Ianiculum vocitaretur. Post ad Ianum 
                solum regnum redactum est, qui creditur geminam faciem praetulisse, 
                ut quae ante quaeque post tergum essent intueretur: quod procul 
                dubio ad prudentiam regis sollertiamque referendum est, qui et 
                praeterita nosset et futura prospiceret, sicut Antevorta et 
                Postvorta, divinitatis scilicet aptissimae comites, apud Romanos 
                coluntur. Hic igitur Ianus, cum Saturnum classe pervectum excepisset 
                hospitio et ab eo edoctus peritiam ruris ferum illum et rudem ante 
                fruges cognitas victum in melius redegisset, regni eum societate 
                muneravit. Cum primus quoque aera signaret, servavit et in hoc 
                Saturni reverentiam, ut, quoniam ille navi fuerat advectus, ex una 
                quidem parte sui capitis effigies, ex altera vero navis 
                exprimeretur, quo Saturni memoriam in posteros propagaret. Aes ita 
                fuisse signatum hodieque intellegitur in aleae lusum, cum pueri 
                denarios in sublime iactantes capita aut navia lusu teste 
                vetustatis exclamant."


                Macrobius Ambrosius Theodosius (ca. AD 385/390—430) a.k.a.
                Macrobius: Macrobii Theodosii (viri) Illustrissimi Saturnaliorum 
                Libri I 7:19—22 (The Saturnalia, Book 1: 7:19—22). [16] 


Despite Macrobius, too, says that Ianus was the first who impressed upon copper 
coins anything, the first figures may actually have been that of sheep and oxen by 
the legendary sixth king of Rome, Servius Tullius (578—535 BC) who in reality might
also have been the first to have an impress made upon copper coins.[17]


Before Servius Tullius' time, according Τιμαῖος (c. 350–260 BC, a.k.a. Timaios 
a.k.a. Timaeus of Taormina a.k.a. Tauromenium a.k.a. Ταυρομένιον, who wrote 'The 
Histories' containing the history of Greece from its earliest days untill the first 
Punic war and was according to Πολύβιος (c. 200–118 BC, a.k.a. Polybius) popularly 
regarded as 'the first historian of Rome'), at Rome the raw metal only was used. [18] 
The form of a sheep was widely believed to be the first figure impressed upon money, 
and to this fact it was said it owes its name, 'pecunia.'[19]


Silver was not impressed with a mark until the year of the City 485 (269 BC), the 
year of the consulship of Q. Ogulnius Gallus and C. Fabius Pictor and five years 
before the First Punic War (264—241 BC), at which time it was ordained that the value
of the currency should follow along similar lines to what is being depicted below: [20]


    Values in 269 BC:


        denarius    = ten librae of copper              : 3274.5 g      : 115.5046 oz
        quinarius   = five librae of copper             : 1637.25 g     : 57.75229 oz
        sestertius  = two librae and a half of copper   : 818.625 g     : 28.87615 oz [20]


The weight, however, of the libra of copper was diminished during the First Punic War, 
as the republic was not having the means to meet its expenditure — in consequence of 
which, an ordinance was made that the 'as' [21] should in future be struck of two 
ounces weight. By this contrivance a saving of nearly five-sixths (82,7 %) was 
gained, and the public debt was liquidated. The impression upon these new "reduced" 
copper coins was a two-faced Ianus on one side, and the beak of a ship of war on 
the other: the triens (one third of an 'as') however, and the quadrans (one fourth 
of an 'as') bore the impression of a ship. The quadrans, too, had, previously to this,
been called 'teruncius,' as being three unciae (one twelveth of an 'as') in weight. [22]


At a later period again, when Hannibal was pressing hard upon Rome, during the 
dictatorship of Q. Fabius Maximus Verrucosus Cunctator (c. 280—203 BC), asses of one 
ounce weight were struck, and it was ordained that the value of the currency should 
follow similar guidelines to which are depicted below:... [23]


    Values in 218–204 BC:


        denarius    = sixteen asses of copper           : 453.5924 g     : 16 oz
        quinarius   = eight asses of copper             : 226.7962 g     : 8 oz
        sestertius  = four asses of copper              : 113.3981 g     : 4 oz [23]


by which last reduction of the weight of the as the republic made a clear gain of 
one half. Still, however, so far as the pay of the soldiers was concerned, one 
denarius had always been given for every ten asses and that practice was prevalent 
until the state became dysfunctional. The impressions upon the coins of silver were 
two-horse and four-horse chariots, and hence it is that they received the names of 
'bigatus, bigati' and 'quadrigatus, quadrigati'.[24] The 'as' kept diminshing in 
its value so that during the Cicero's time (106—43 BC) the 'as' had lost nearly 
all its value and the name 'as' had entered into idioms, such as...


    The Usage of 'as, assis' in some of the Latin Idioms


        assem nullum dare               to not pay a penny /                (Cic. Q. Rosc. 16:49)
                                        (lit.) to not give a dime

        ad assem omnia perdere          to lose everything to               (Hor. Ep. 2.2:27—28)
                                        the last penny

        vilem redigi ad assem           to diminish in value and            (Hor. S. 1.1:43) 
                                        depreciate until worth 
                                        only a worthless penny


...and a few centuries later, as described by Macrobius, these copper coins 
were being used as toys when kids on the street threw them in the air 
shouting 'capita' or 'navia' trying to guess the outcome beforehand.



___________________________

[1]     Németh 2013, 55—56; Rowan 2009, 7; Melville-Jones 1993, no. 657;
        http://www.perseus.tufts.edu/hopper/morph?l=xalkismos&la=greek#lexicon — Χαλκισμός

[2]     Ἰούλιος Πολυδεύκης Ναυκρατίτης a.k.a. Julius Pollux: https://archive.org/details/onomasticon01polluoft — Ὀνομαστικόν' (Onomasticon): Vol. IX, 118. (Greek)
        https://archive.org/stream/onomasticon01polluoft/onomasticon01polluoft_djvu.txt — Full text of "Onomasticon"
        Julius Pollux: https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft.pdf — Onomasticon: Vol. VI-X, Color (Greek) (PDF, 17.1 MB)
        Julius Pollux: https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft_bw.pdf — Onomasticon: Vol. VI-X, BW (Greek) (PDF, 13.1 MB)
        https://openlibrary.org/works/OL10686184W/Onomasticon — Onomasticon (10 editions) By Julius Pollux

[3]     Németh 2013, 56; Rowan 2009, 7.
        (Macrobii Saturnalia Liber I: 7:19—24): Macrobius Ambrosius Theodosius (ca. AD 385/390—430), http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Macrobius/Saturnalia/1*.html — 'Macrobii Theodosii (viri) Illustrissimi Saturnaliorum, Libri I' 7:19—24 (The Saturnalia, Book 1) (Latin)
        (Ov. Fast. 1, 229—255): P. Ovidius Naso (43 BC – AD 18), a.k.a. Ovid), http://www.perseus.tufts.edu/hopper/text?doc=Ov.%20Fast.%201.239&lang=original — 'Fasti' 1:229—255 (The Festivals) (Latin)
        (Aur. Vict. Orig. Gent. R. 3:1-7) Author Unknown – Incerti Auctoris – Sextus Aurelius Victor (c. AD 320–390), http://www.forumromanum.org/literature/victor_orig.html — 'Origo Gentis Romanae' (The Origins of the Roman People) 3:1-7 ...Incerti Auctoris... (Latin) http://www.tertullian.org/fathers/origo_01_trans.htm — Anonymous: On the Origin of the Roman People 3:1-7 (English) http://www.thelatinlibrary.com/victor.origio.html — alternative latin (Latin)

[4]     (Aur. Vict. Orig. Gent. R. 3:1-7) Author Unknown – Incerti Auctoris – Sextus Aurelius Victor (c. AD 320–390), http://www.forumromanum.org/literature/victor_orig.html — 'Origo Gentis Romanae' (The Origins of the Roman People) 3:1-7 ...Incerti Auctoris... (Latin) http://www.tertullian.org/fathers/origo_01_trans.htm — Anonymous: On the Origin of the Roman People 3:1-7 (English) http://www.thelatinlibrary.com/victor.origio.html — alternative latin (Latin)

[5]     (Aur. Vict. Orig. Gent. R. 3:1-7) Author Unknown – Incerti Auctoris – Sextus Aurelius Victor (c. AD 320–390), http://www.roman-emperors.org/origogentis.pdf — 'Origo Gentis Romanae' (The Origins of the Roman People) 3:1-7 ...Incerti Auctoris... Translated by Kyle Haniszewski, Lindsay Karas, Kevin Koch, Emily Parobek, Colin Pratt, and Brian Serwicki; Thomas M. Banchich, Supervisor; Canisius College Translated Texts, Number 3, Canisius College, Buffalo, New York 2004 (PDF, 422 KB) (English)

[6]     (Ov. Fast. 1, 185—255): P. Ovidius Naso (43 BC – AD 18), a.k.a. Ovid), https://ia800500.us.archive.org/6/items/ovidsfasti00oviduoft/ovidsfasti00oviduoft_bw.pdf — 'Fasti' 1:185—255 (The Festivals) BW (PDF, 15.4 MB) (Latin and English) https://ia800500.us.archive.org/6/items/ovidsfasti00oviduoft/ovidsfasti00oviduoft.pdf — 'Fasti' 1:185—255 (The Festivals) Color (PDF, 20.1 MB) (Latin and English)
        https://archive.org/stream/ovidsfasti00oviduoft/ovidsfasti00oviduoft_djvu.txt — txt (English)
        http://www.thelatinlibrary.com/ovid/ovid.fasti1.shtml — alternative latin (Latin)
                    Sim. P. Ovidius Naso, http://www.perseus.tufts.edu/hopper/text?doc=Ov.+Fast.+1.185 — 'P. Ovidius Naso. Ovid's Fasti. Sir James George Frazer. London; Cambridge, MA. William Heinemann Ltd.' Harvard University Press. 1933. (Latin)

[7]     http://www.catholic.org/saints/saint.php?saint_id=5329 — St. Paulinus of Nola
        http://our-catholic-faith.com/beings/saints/saint/st-paulinus-of-nola — St. Paulinus of Nola
        http://www.ewtn.com/saintsHoly/saints/P/stpaulinusofnola.asp — St. Paulinus of Nola: Bishop and Writer

[8]     (Paul. Nol. Poëm. 32:65—77): Pontius Paulinus Nolanus (c. AD 353–431, a.k.a. Pontius Meropius Anicius Paulinus a.k.a. Paulinus of Nola), http://archive.org/stream/corpusscriptoru25wiengoog#page/n391/mode/2up/search/capita — 'Corpus scriptorum ecclesiasticorum Latinorum, Vol 30' Carmen 32:65—77 A series of critical editions of the Latin Church Fathers, Österreichische Akademie der Wissenschaften. 1894. (https://ia801406.us.archive.org/14/items/corpusscriptoru25wiengoog/corpusscriptoru25wiengoog.pdf — PDF, 13.9 MB) (Latin)

[9]     Németh 2013, 56; Rowan 2009, 7.
        (Paul. Nol. Poëm. 32:65—77): Pontius Paulinus Nolanus (c. AD 353–431, a.k.a. Pontius Meropius Anicius Paulinus a.k.a. Paulinus of Nola), http://archive.org/stream/corpusscriptoru25wiengoog#page/n391/mode/2up/search/capita — 'Corpus scriptorum ecclesiasticorum Latinorum, Vol 30' Carmen 32:65—77 A series of critical editions of the Latin Church Fathers, Österreichische Akademie der Wissenschaften. 1894. (https://ia801406.us.archive.org/14/items/corpusscriptoru25wiengoog/corpusscriptoru25wiengoog.pdf — PDF, 13.9 MB) (Latin)
        http://www.perseus.tufts.edu/hopper/morph?l=capita&la=la#lexicon — Capita aut navia
        http://www.perseus.tufts.edu/hopper/morph?l=navia&la=la#lexicon — Navia

[10]    http://www.perseus.tufts.edu/hopper/morph?l=navia&la=la#lexicon — Navia

[11]    (Aur. Vict. Orig. Gent. R. 3:5) Author Unknown – Incerti Auctoris – Sextus Aurelius Victor (c. AD 320–390), http://www.forumromanum.org/literature/victor_orig.html — 'Origo Gentis Romanae' (The Origins of the Roman People) 3:5 ...Incerti Auctoris... (Latin) http://www.tertullian.org/fathers/origo_01_trans.htm — Anonymous: On the Origin of the Roman People 3:5 (English) http://www.thelatinlibrary.com/victor.origio.html — alternative latin (Latin)

[12]    Aurelius Augustinus Hipponensis (AD 354–430, a.k.a. Augustine of Hippo ), http://www.augustinus.it/latino/anima_origine/index2.htm — 'De Anima et Eius Origine, Liber IV' (A Treatise on the Soul and Its Origin, Book IV) Chapter 20 [XIV] called 'Quisnam sit interior videamus: utrum anima, an spiritus, an utrumque' (What kind of an inner man do we see: the soul, the spirit or both) (Latin) (http://www.ccel.org/ccel/schaff/npnf105.pdf — PDF, 10 MB) (English)
        https://www3.nd.edu/~maritain/jmc/etext/homp098.htm — St. Augustine. His Life and Works

[13]    Aurelius Augustinus Hipponensis (AD 354–430, a.k.a. Augustine of Hippo ), http://www.augustinus.it/latino/anima_origine/index2.htm — 'De Anima et Eius Origine, Liber IV' (A Treatise on the Soul and Its Origin, Book IV) Chapter 20 [XIV] called 'Quisnam sit interior videamus: utrum anima, an spiritus, an utrumque' (What kind of an inner man do we see: the soul, the spirit or both) (Latin) (http://www.ccel.org/ccel/schaff/npnf105.pdf — PDF, 10 MB) (English)
        https://www3.nd.edu/~maritain/jmc/etext/homp098.htm — St. Augustine. His Life and Works
        (Cic. Catil. 2.10.22–23) Marcus Tullius Cicero a.k.a. Κικέρων, (106–43 BC), https://ia601406.us.archive.org/14/items/mtulliciceronis19cicegoog/mtulliciceronis19cicegoog.pdf — 'M. Tulli Ciceronis in L. Catilinam orationes quattuor': In L. Catilinam Oratio Secunda Habita Ad Populum 10.22–23 (The Second oration of Marcus Tullius Cicero against Lucius Catilina, Addressed to the People. 10.22–23) 1906 (PDF, 3 MB) (Latin) https://www.archive.org/stream/orationsofcicero00ciceuoft/orationsofcicero00ciceuoft_djvu.txt — The Orations of Cicero against Catiline (txt) (Latin) http://latin.packhum.org/loc/474/13/1#1 — alternative latin (Latin)
                    Sim. M. Tullius Cicero, http://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.02.0010%3Atext%3DCatil.%3Aspeech%3D2 — 'M. Tulli Ciceronis Orationes: Recognovit brevique adnotatione critica instruxit Albertus Curtis Clark Collegii Reginae Socius.' Albert Curtis Clark. Oxonii. e Typographeo Clarendoniano. 1908. Scriptorum Classicorum Bibliotheca Oxoniensis. (Latin)
                    For a translation, please see for example M. Tullius Cicero, http://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.02.0019%3Atext%3DCatil.%3Aspeech%3D2 — 'M. Tullius Cicero. The Orations of Marcus Tullius Cicero, literally translated by C. D. Yonge, B. A.' London. Henry G. Bohn, York Street, Covent Garden. 1856. (English)

[14]    (Cic. Catil. 2.10.22–23) Marcus Tullius Cicero a.k.a. Κικέρων, (106–43 BC), https://ia601406.us.archive.org/14/items/mtulliciceronis19cicegoog/mtulliciceronis19cicegoog.pdf — 'M. Tulli Ciceronis in L. Catilinam orationes quattuor': In L. Catilinam Oratio Secunda Habita Ad Populum 10.22–23 (The Second oration of Marcus Tullius Cicero against Lucius Catilina, Addressed to the People. 10.22–23) 1906 (PDF, 3 MB) (Latin) https://www.archive.org/stream/orationsofcicero00ciceuoft/orationsofcicero00ciceuoft_djvu.txt — The Orations of Cicero against Catiline (txt) (Latin) http://latin.packhum.org/loc/474/13/1#1 — alternative latin (Latin)
                    Sim. M. Tullius Cicero, http://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.02.0010%3Atext%3DCatil.%3Aspeech%3D2 — 'M. Tulli Ciceronis Orationes: Recognovit brevique adnotatione critica instruxit Albertus Curtis Clark Collegii Reginae Socius.' Albert Curtis Clark. Oxonii. e Typographeo Clarendoniano. 1908. Scriptorum Classicorum Bibliotheca Oxoniensis. (Latin)
                    For a translation, please see for example M. Tullius Cicero, http://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.02.0019%3Atext%3DCatil.%3Aspeech%3D2 — 'M. Tullius Cicero. The Orations of Marcus Tullius Cicero, literally translated by C. D. Yonge, B. A.' London. Henry G. Bohn, York Street, Covent Garden. 1856. (English)

[15]    Németh 2013, 56; Rowan 2009, 7.
        (Macrobii Saturnalia Liber I: 7:19—22): Macrobius Ambrosius Theodosius (ca. AD 385/390—430), http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Macrobius/Saturnalia/1*.html — 'Macrobii Theodosii (viri) Illustrissimi Saturnaliorum, Libri I' 7:19—22 (The Saturnalia, Book 1) (Latin)

[16]    (Macrobii Saturnalia Liber I: 7:19—22): Macrobius Ambrosius Theodosius (ca. AD 385/390—430), http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Macrobius/Saturnalia/1*.html — 'Macrobii Theodosii (viri) Illustrissimi Saturnaliorum, Libri I' 7:19—22 (The Saturnalia, Book 1) (Latin)

[17]    (Macrobii Saturnalia Liber I: 7:19—24): Macrobius Ambrosius Theodosius (ca. AD 385/390—430), http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Macrobius/Saturnalia/1*.html — 'Macrobii Theodosii (viri) Illustrissimi Saturnaliorum, Libri I' 7:19—24 (The Saturnalia, Book 1) (Latin)
        (Ov. Fast. 1, 235—255): P. Ovidius Naso (43 BC – AD 18), a.k.a. Ovid), http://www.perseus.tufts.edu/hopper/text?doc=Ov.%20Fast.%201.239&lang=original — 'Fasti' 1:235—255 (The Festivals) (Latin)
        (Plin. Nat. 33.13): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13 — 'Naturalis Historiae' (The Natural History) 33.13 The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855. (English)
        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13 — alternative link (English)
        (Plin. Nat. 18.3): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:18.3 — 'Naturalis Historiae' (The Natural History) 18.3 The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855. (English)
        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=18:chapter=3 — alternative link (English)

[18]    Usher 2009, 488;
        http://www.bestofsicily.com/mag/art231.htm — Timaeus of Taormina
        (Plin. Nat. 33.13): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13 — 'Naturalis Historiae' (The Natural History) 33.13 The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855. (English)
        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13 — alternative link (English)
        (Plin. Nat. 18.3): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:18.3 — 'Naturalis Historiae' (The Natural History) 18.3 The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855. (English)
        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=18:chapter=3 — alternative link (English)

[19]    From 'pecus, pecoris': a sheep, a goat or cattle. For instance, Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), 'Naturalis Historiae' (The Natural History) 18.3
        Plinius 'Naturalis Historiae' 18.3: 'Pecunia ipsa a pecore appellabatur.'
        (Plin. Nat. 18.3): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), https://la.wikisource.org/wiki/Naturalis_Historia/Liber_XVIII — 'Naturalis Historiae' (The Natural History) 18.3 (Latin)
                    Sim. Gaius Plinius Secundus (a.k.a. Pliny the Elder), http://www.perseus.tufts.edu/hopper/text?doc=Plin.+Nat.+18.3&fromdoc=Perseus%3Atext%3A1999.02.0138 — 'Naturalis Historiae' (The Natural History) 18.3 (Latin) Teubner</ol></ol></ol>
        (Plin. Nat. 33.13): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13 — 'Naturalis Historiae' (The Natural History) 33.13 The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855. (English)
        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13 — alternative link (English)


[20]    one libra, librae           : 327.45 g          : 11.55046 oz        a unit of measurement


        (Plin. Nat. 33.13): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13 — 'Naturalis Historiae' (The Natural History) 33.13 The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855. (English)
        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13 — alternative link (English)


[21]    One as, assis


        as, assis (original)                       : 327.45 g          : 11.55046 oz       a coin ('as librarius') or a unit of measurement
        as, assis (after the First Punic War)      : 56.69905 g        : 2 oz              a coin or a unit of measurement
        as, assis (after the Second Punic War)     : 28.34952 g        : 1 oz              a coin or a unit of measurement



        One 'as' was divided, for instance:     Name        Value       Decimal
                                                ----        -----       -------
                                                deunx       = 11/12     ≈ 91.7 %
                                                dextans     = 5/6       ≈ 83.3 %
                                                dodrans     = 3/4       = 75 %
                                                bes         = 2/3       ≈ 66.7 %
                                                septunx     = 7/12      ≈ 58.3 %
                                                semis       = 1/2       = 50 %
                                                quicunx     = 5/12      ≈ 41.7 %
                                                triens      = 1/3       ≈ 33.3 %
                                                quadrans    = 1/4       = 25 %
                                                sextans     = 1/6       ≈ 16.7 %
                                                uncia       = 1/12      ≈ 8.3 %


[22]    (Plin. Nat. 33.13): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13 — 'Naturalis Historiae' (The Natural History) 33.13 The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855. (English)
        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13 — alternative link (English)

[23]    Ibid.

[24]    Ibid.






  ____  _ _     _ _                             _
 |  _ \(_) |   | (_)                           | |
 | |_) |_| |__ | |_  ___   __ _ _ __ __ _ _ __ | |__  _   _
 |  _ <| | '_ \| | |/ _ \ / _` | '__/ _` | '_ \| '_ \| | | |
 | |_) | | |_) | | | (_) | (_| | | | (_| | |_) | | | | |_| |
 |____/|_|_.__/|_|_|\___/ \__, |_|  \__,_| .__/|_| |_|\__, |
                           __/ |         | |           __/ |
                          |___/          |_|          |___/

Bibliography:

Melville-Jones,John (1993): 'Testimonia Numaria: Greek and Latin texts concerning ancient Greek coinage' Vol 1: Texts and Translations (London)."

Németh, György (2013):  'Coins In Water'
                        ACTA CLASSICA UNIV. SCIENT. DEBRECEN. XLIX., pp. 55–63.
                        https://www.researchgate.net/publication/258434610_COINS_IN_WATER

Rowan, Clare (2009):    'Slipping out of circulation: the after-life of coins in the Roman World.'
                        Journal of the Numismatic Association of Australia Vol. 20, pp. 3–14.
                        http://www.numismatics.org.au/pdfjournal/Vol20/Vol%2020%20Article%201.pdf

Teitel, Stephen:        'Theory of Probability.'
                        http://www.pas.rochester.edu/~stte/phy104-F00/notes-2.html

Usher, Stephen (2009):  'Oratio Recta and Oratio Obliqua in Polybius'
                        Greek, Roman, and Byzantine Studies 49, pp. 487—514
                        http://grbs.library.duke.edu/article/download/1301/1381





   _____
  / ____|
 | (___   ___  _   _ _ __ ___ ___
  \___ \ / _ \| | | | '__/ __/ _ \
  ____) | (_) | |_| | | | (_|  __/
 |_____/ \___/ \__,_|_|  \___\___|


https://community.spiceworks.com/scripts/show/1712-start-countdown                            # Martin Pugh: "Start-Countdown"
http://stackoverflow.com/questions/10941756/powershell-show-elapsed-time                      # Jeff: "Powershell show elapsed time"




  _    _      _
 | |  | |    | |
 | |__| | ___| |_ __
 |  __  |/ _ \ | '_ \
 | |  | |  __/ | |_) |
 |_|  |_|\___|_| .__/
               | |
               |_|
#>

<#

.SYNOPSIS
Toss a coin or play the ancient Greek game called 'Chalkismos' or the ancient Roman
game 'Capita aut navia'.

.DESCRIPTION
The regular action in the Toss-a-Coin is to toss a coin (or flip a coin, the game
of 'Heads or Tails'). The result of a coin toss is displayed in console after the
user settable amount of delay (defined in milliseconds with the parameter -Delay,
which has the aliases called -Wait and -Pause).

To play a regular round of the ancient Greek game called 'Chalkismos', a parameter
-Greek may be used in the command. To challenge the all-time best chalkismos-player,
an additional parameter -Phryne could be used in combination with or without the
-Greek parameter. To see an actual description of the game in original language,
please see the History section (in the source code comments since Windows PowerShell
doesn't work very well when trying to display the fully accented ancient Greek
characters).

To play the ancient Roman game 'Capita aut navia?', a parameter -Roman may be used
in the command. To read more about the origins and the very name of the game itself
and about the terms used please refer to the History section (inside the source
code).

To see the the rules of a game, a parameter -Help (which has the aliases of -Text
and -Definition and -Rules) may be added to each and every command. The definitions
of each game are decribed in the Description section below. To hear the result in
code language, an -Audio parameter may be added to the command.

.PARAMETER Greek
To play a regular round of the ancient Greek game called 'chalkismos', a parameter
-Greek may be used in the command. To challenge the all-time best chalkismos-player,
an additional parameter -Phryne could be used in combination with or without the
-Greek parameter.

.PARAMETER Phryne
To play a regular round of the ancient Greek game called 'chalkismos', a parameter
-Greek may be used in the command. To challenge the all-time best chalkismos-player,
an additional parameter -Phryne could be used in combination with or without the
-Greek parameter.

.PARAMETER Roman
To play the ancient Roman game 'Capita aut navia?', a parameter -Roman may be used
in the command.

.PARAMETER Delay
The result of a coin toss is displayed in console after the user settable amount of
delay (defined in milliseconds with the parameter -Delay, which has the aliases
called -Wait and -Pause). The value should be an integer between 0 and ten billion.
All values under 1000 (one second) are shown without a progress bar, and for
instance, a value of 750 results in a slower pace without any progress bars and a
value of 178 is a reasonable responsive UX without any progress bars. The default
value is 3178, which shows the result after roughly three seconds and displays a
progress bar to count down the time. To get the result instantly, please set the
value of parameter -Delay to number zero (-Delay 0). The threshold level for the
delay, above which additional instructions to cancel the countdown are displayed
is defined on line 29 with the $delay_notify_threshold variable (in milliseconds).
The usage of fractions of milliseconds with the -Delay parameter is not supported.

.PARAMETER Help
To see the the rules of a game, a parameter -Help (which has the aliases of -Text
and -Definition and -Rules) may be added to each and every command.

.PARAMETER Audio
If the -Audio parameter is used in the command, after the results have been displayed
a morse code character i (two beeps) or a morse code character 5 (five beeps) is
emitted through the speakers. The default audio mode in Toss-a-Coin is "silent". To
find out, which sound is emitted when, please see the table below.


            Morse Code Character i        Morse Code Character 5
            ----------------------        ----------------------
                  [two beeps]                   [five beeps]

                    Heads                          Tails
                    Capita                         Navia
                    Success                        Fail


.OUTPUTS
Generates an output of a selected game in console. Displays a progress bar, if
-Delay is set over 1000 (one second). Emits a sound, if -Audio parameter is used.

.NOTES
Please note that each of the parameters can be "tab completed" before typing them
fully (by pressing the [tab] key, not including the aliases).

Please note that the two ancient games cannot effectively be played at the
same time with using only one coin due to the radically different nature of the games.

Please see the Description section below for definitions of each game.


    Description


    (1) Chalkismos          "After a player has set a coin spinning on the table
                            and while the coin still spins freely with reasonably
                            good amount of spin around its center axel, the player
                            tries to stop it with an extended straight index finger
                            without the coin bouncing away."

                            "The idea is to 'catch' or 'lock' the wildly spinning
                            coin under the tip of a straight finger. Additionally it
                            may be agreed upon that if any part of the coin extends
                            under the first joint after the attempt, the attempt is
                            considerd to be disqualified. Also it may be agreed upon
                            that the remaing four fingertips of the primary hand
                            must be placed on the table before an attempt to catch
                            the coin is made."




    (2) Capita aut navia?   "In coin flipping (or coin tossing) an outcome is
                            pronounced by each participant before a correct answer
                            is revealed to the question, which side of a coin is
                            facing upwards after the said coin has been tossed in
                            the air. An ideal coin toss includes as many rotations
                            around the coin's centre axel as possible (while the
                            coin is still in the air). Linguistically oriented
                            participants might call the obverse 'caput', if there's
                            a single item depicted on the coin's obverse side, and
                            'capita' in case two or more similar items are depicted
                            on the coin's obverse. Historically oriented
                            participants might call the obverse 'capita' despite
                            what is being depicted on it. The reverse is usually
                            always called 'navia', but if so agreed upon, perhaps
                            also the more linguistically correct forms may be
                            accepted as an alternative name to the traditional
                            reverse side name of 'navia'. Please see the History
                            section (inside the source code) for further debate on
                            this subject."

                            "It is not always easy to decide what is heads and tails
                            on a given coin. Numismatics defines the obverse and
                            reverse of a coin rather than heads and tails. The
                            obverse (principal side) of a coin typically features
                            a symbol intended to be evocative of stately power, such
                            as the head of a monarch or well-known state
                            representative. In the case of coins that do not have
                            royalty or state representatives on them, the side that
                            features the name of the country is usually considered
                            the obverse. Source: [https://www.random.org/coins/]"




    (3) Coin toss           "In coin flipping (or coin tossing) an outcome is
                            pronounced by each participant before a correct answer
                            is revealed to the question, which side of a coin is
                            facing upwards after the said coin has been tossed in
                            the air. An ideal coin toss includes as many rotations
                            around the coin's centre axel as possible (while the
                            coin is still in the air)."

                            "It is not always easy to decide what is heads and tails
                            on a given coin. Numismatics defines the obverse and
                            reverse of a coin rather than heads and tails. The
                            obverse (principal side) of a coin typically features
                            a symbol intended to be evocative of stately power, such
                            as the head of a monarch or well-known state
                            representative. In the case of coins that do not have
                            royalty or state representatives on them, the side that
                            features the name of the country is usually considered
                            the obverse. Source: [https://www.random.org/coins/]"


    Homepage:           https://github.com/auberginehill/toss-a-coin
                        Short URL: http://tinyurl.com/zugcp5h
    Version:            1.2

.EXAMPLE
./Toss-a-Coin

Run the script. Please notice to insert ./ or .\ before the script name.
Uses the default game mode (a coin flip) and generates the result after the
default delay time of 3178 milliseconds.

.EXAMPLE
help ./Toss-a-Coin -Full
Display the help file.

.EXAMPLE
./Toss-a-Coin -Help -Delay 10000
Run the script, use the default game mode (a coin flip) and display the rules of
coin tossing and show the result after ten seconds.

.EXAMPLE
./Toss-a-Coin -Greek -Pause 1500 -Audio
Run the script and play a regular round of the ancient game called 'chalkismos'
and display the result after an second and a half delay. Confirm the results with
an audible beep, which will vary depending on the result. This command will work,
because -Pause is an alias of -Delay.

.EXAMPLE
./Toss-a-Coin -Greek -Text
Run the script and play a regular round of the ancient game called 'chalkismos'
and display the rules of the ancient Greek game called 'chalkismos'. Generates
the result after the default delay time of 3178 milliseconds. This command will
work, because -Text is an alias of -Help.

.EXAMPLE
./Toss-a-Coin -Greek -Phryne -Definition -Delay 0
Run the script and play the ancient game called 'chalkismos' against the all-time
best chalkismos-player and also display the rules of the ancient Greek game
called 'chalkismos' and get the results instantly without any delay. This command
will work, because -Definition is an alias of -Help.

Please note that when playing against Phryne, it's not mandatory to use the
-Greek parameter (in this case when the rules are being displayed a command
./Toss-a-Coin -Phryne -Help -Delay 0 would result in a similar outcome).

.EXAMPLE
./Toss-a-Coin -Roman -Rules -Wait 5000 -Audio
Run the script, play the ancient Roman game 'Capita aut navia?' and display the
rules of the ancient Roman game called 'Capita aut navia?' and don't display the
the result until five seconds have passed. After the result has been shown, confirm
the result by emitting a different sound for different results. This command will
work, because -Rules is an alias of -Help and -Wait is an alias of -Delay.

.EXAMPLE
Set-ExecutionPolicy remotesigned

This command is altering the Windows PowerShell rights to enable script execution. Windows PowerShell
has to be run with elevated rights (run as an administrator) to actually be able to change the script
execution properties. The default value is "Set-ExecutionPolicy restricted".


    Parameters:

    Restricted      Does not load configuration files or run scripts. Restricted is the default
                    execution policy.

    AllSigned       Requires that all scripts and configuration files be signed by a trusted
                    publisher, including scripts that you write on the local computer.

    RemoteSigned    Requires that all scripts and configuration files downloaded from the Internet
                    be signed by a trusted publisher.

    Unrestricted    Loads all configuration files and runs all scripts. If you run an unsigned
                    script that was downloaded from the Internet, you are prompted for permission
                    before it runs.

    Bypass          Nothing is blocked and there are no warnings or prompts.

    Undefined       Removes the currently assigned execution policy from the current scope.
                    This parameter will not remove an execution policy that is set in a Group
                    Policy scope.


For more information, please type "help Set-ExecutionPolicy -Full" or visit
https://technet.microsoft.com/en-us/library/hh849812.aspx.

.EXAMPLE
New-Item -ItemType File -Path C:\Temp\Toss-a-Coin.ps1

Creates an empty ps1-file to the C:\Temp directory. The New-Item cmdlet has an inherent -NoClobber mode
built into it, so that the procedure will halt, if overwriting (replacing the contents) of an existing
file is about to happen. Overwriting a file with the New-Item cmdlet requires using the Force.
For more information, please type "help New-Item -Full".

.LINK
https://www.researchgate.net/publication/258434610_COINS_IN_WATER
http://www.numismatics.org.au/pdfjournal/Vol20/Vol%2020%20Article%201.pdf
http://www.pas.rochester.edu/~stte/phy104-F00/notes-2.html
http://grbs.library.duke.edu/article/download/1301/1381
http://www.perseus.tufts.edu/hopper/morph?l=xalkismos&la=greek#lexicon
https://archive.org/details/onomasticon01polluoft
https://archive.org/stream/onomasticon01polluoft/onomasticon01polluoft_djvu.txt
https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft.pdf
https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft_bw.pdf
https://openlibrary.org/works/OL10686184W/Onomasticon
http://www.perseus.tufts.edu/hopper/morph?l=capita&la=la#lexicon
https://ia801406.us.archive.org/14/items/corpusscriptoru25wiengoog/corpusscriptoru25wiengoog.pdf
http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Macrobius/Saturnalia/1*.html
http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:18.3
http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=18:chapter=3
http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13
http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13
http://www.bestofsicily.com/mag/art231.htm
https://la.wikisource.org/wiki/Naturalis_Historia/Liber_XVIII
http://www.perseus.tufts.edu/hopper/text?doc=Plin.+Nat.+18.3&fromdoc=Perseus%3Atext%3A1999.02.0138
https://technet.microsoft.com/en-us/library/hh847743.aspx
http://stackoverflow.com/questions/10941756/powershell-show-elapsed-time
https://community.spiceworks.com/scripts/show/1712-start-countdown
http://poshcode.org/1192
https://technet.microsoft.com/en-us/library/hh847796.aspx
https://technet.microsoft.com/en-us/magazine/hh360993.aspx
https://technet.microsoft.com/en-us/library/ee692803.aspx

#>
