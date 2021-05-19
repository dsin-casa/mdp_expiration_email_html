#######Variables a éditer
#email expediteur
$MSender = "no-reply@domain.local"
#email correspondant cc
$MSender_final="support.informatique@domain.local"
#$cc= "support.informatique@domain.local"
# Addresse IP ou nom du serveur SMTP
$MServer = "smtp.domain.local"
# Chemin de recherche Annuaire Active Directory
$Ldappath = "OU=Utilisateurs,DC=domain,DC=local"

#Logo de entreprise + site WEB
$logo_img = "https://"
$site_web = "https://"
#Réseaux sociaux
$facebook_img = "https://"
$facebook_url = "https://"
$twitter_img = "https://"
$twitter_url = "https://"
$linkedin_img = "https://"
$linkedin_url = "https://"
#autresliens utilisés pour le corps de message
$clavier_img = "https://"
$menumdp_img = "https://"
$changemdp_img = "https://"
$generateur_img = "https://"
$generateur_url= "https://"
$wifi_img = "https://"
$wifi_notice = "https://"
$messagerie_img = "https://"
$messagerie_notice= "https://"
$smartphone_img = "https://"

########## Fontion d'envoi d'email
function Send-SMTPmail($to, $from, $subject, $body, $attachment, $cc, $port, $timeout, $smtpserver, [switch] $html, [switch] $alert)
{
    if ($null -eq $smtpserver) {$smtpserver = $MServer}
    $mailer = new-object Net.Mail.SMTPclient($smtpserver)
    if ($null -ne $port) {$mailer.port = $port}
    if ($null -ne $timeout) {$mailer.timeout = $timeout}
    $msg = new-object Net.Mail.MailMessage($from,$to,$subject,$body)
    if ($html) {$msg.IsBodyHTML = $true}
    if ($null -ne $cc) {$msg.cc.add($cc)}
    if ($alert) {$msg.Headers.Add("message-id", "<3bd50098e401463aa228377848493927-1>")}
    if ($null -ne $attachment)
    {
        $attachment = new-object Net.Mail.Attachment($attachment)
        $msg.attachments.add($attachment)
    }
    $mailer.send($msg)
}

# Chargement du module PowerShell Quest
add-PSSnapin -Name Quest.ActiveRoles.ADManagement -ErrorAction SilentlyContinue

#Formater la valeur date du jour JJ/MM/AA
$Today = get-date -format d
#Recherche des utilisateurs ayant une date expiration de mot de passe
$users = Get-ADUser -Filter 'enabled -eq $true' -Searchbase $Ldappath -Properties *,"msDS-UserPasswordExpiryTimeComputed" | where-object {$_.PasswordNeverExpires -eq $false} | Select-Object *,@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

#Boucle sur les utilisateurs de verification du nombre de jour avant expiration et action en fonction du résultat
$users_list =  
foreach ($user in $users)
{
#write-host $users.mail
#write-host $user.ExpiryDate

     if ([datetime]::FromFileTime((Get-ADUser -Identity $user.SamAccountName -Properties "msDS-UserPasswordExpiryTimeComputed")."msDS-UserPasswordExpiryTimeComputed"))
     {
        $usrmail = $user.mail

        $usrname = $user.SamAccountName
        $usrlogin = $User.sAMAccountName
        $ExpiredDate = [datetime]::FromFileTime((Get-ADUser -Identity $user.SamAccountName -Properties "msDS-UserPasswordExpiryTimeComputed")."msDS-UserPasswordExpiryTimeComputed")
        $today = (get-date).date
        #$today = (get-date -date 22/08/2012).date.adddays(-3)
        $difference = $ExpiredDate - $today
        $delays = $difference.Days
        write-host "expiration pour " $user.SamAccountName " :" $user.ExpiryDate
        write-host "durée entre " $today " et " $ExpiredDate " : " $difference.Days
        if ($difference.Days -eq 15)
        {
               $MSubject = "Votre mot de passe va expirer dans 15 jours."
               #mail 15 jours

               $Mbody = "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml' xmlns:v='urn:schemas-microsoft-com:vml' xmlns:o='urn:schemas-microsoft-com:office:office'>
 <head> 
  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'> 
  <meta name='viewport' content='width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1'> 
  <style type='text/css'>
    body {
      width: 100% !important;
      height: 100% !important;
      margin: 0;
      padding: 0;
    }
    html, body, div, span, applet, object, iframe,
    h1, h2, h3, h4, h5, h6, p, blockquote, pre,
    a, abbr, acronym, address, big, cite, code,
    del, dfn, em, img, ins, kbd, q, s, samp,
    small, strike, strong, sub, sup, tt, var,
    b, u, i, center,
    dl, dt, dd, ol, ul, li,
    fieldset, form, label, legend,
    table, caption, tbody, tfoot, thead, tr, th, td,
    article, aside, canvas, details, embed,
    figure, figcaption, footer, header, hgroup,
    menu, nav, output, ruby, section, summary,
    time, mark, audio, video {
      Margin: 0;
      padding: 0;
      border: 0;
    }
    article, aside, details, figcaption, figure,
    footer, header, hgroup, menu, nav, section {
      display: block;
    }
    body {
      line-height: 1;
    }
    blockquote, q {
      quotes: none;
    }
    blockquote:before, blockquote:after,
    q:before, q:after {
      content: '';
      content: none;
    }
    table {
      border-collapse: collapse;
      border-spacing: 0;
    }
    table, td {
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
    }
    .fix-space-td-img {
      font-size:0px;
      line-height:0px;
    }
    .fixed-table-layout {
      table-layout: fixed;
    }
    @media only screen and (max-width: 479px), only screen and (max-device-width: 479px) {
      .hidebloc {
        display: none !important;
      }
      body {
        width: auto !important;
      }
      #conteneur {
        width: 100% !important;
      }
      .full {
        display: block !important;
      }
      .mobile-full-width {
        width: 100% !important;
      }
      td.full {
        display: block !important;
      }
      img {
        max-width: 100% !important;
        height: auto !important;
      }
    }
  </style> 
  <title></title> 
  </head> 
 <body id='conteneur' style='width:100%; word-wrap: break-word;
        word-break: break-word; overflow-wrap: break-word;'> 
  <table id='content_root' width='100%' cellpadding='0' cellspacing='0' style='background-color:#fff;
'> 
   <tbody>
    <tr> 
     <td align='center'> 
      <table cellpadding='0' cellspacing='0' align='center'> 
       <tbody>
        <tr> 
         <td align='left' valign='top'> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         background-color: #fff;
'> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       border-color: #e65100;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 5px 20px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       background-color: #ffffff;
                       border-top-width: 1px;
                       border-top-style: solid;
                       border-right-width: 1px;
                       border-right-style: solid;
                       border-bottom-width: 1px;
                       border-left-width: 1px;
                       border-left-style: solid;
                       border-color: #000;
                     
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%' background='' style='background-image: url(''); background-position: center top; background-size:cover;'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr>
                              <table width='100%' cellpadding='0' cellspacing='0'>
                                <td align='center'> 
                                  <table align='center' cellpadding='0' cellspacing='0'> 
                                   <tbody>
                                    <tr> 
                                      <td align='left'> <a href='$site_web' target='_blank' style='text-decoration: none !important;'> <img src='$logo_img' width='250'> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td>
                                <tbody>
                                 <tr>                                     
                              <td align='center' style='
            padding: 0px 0px 0px 0px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h1 style='font-family: Arial;
        font-size: 30px;
        font-weight: normal;line-height: 40px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'><span style='font-size: 27px; font-family: Lobster, cursive; color: #ffffff; line-height: 40px; mso-line-height-rule: exactly;'><span style='color: #ffffff;'></span></span></h1> <h1 style='font-family: Arial;
        font-size: 20px;
        font-weight: normal;line-height: 40px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'><span style='font-size: 19px; font-family: verdana , cursive; bold; color: #ffffff; line-height: 40px; mso-line-height-rule: exactly;'><span style='color: #2c303b;'><strong>Direction des Systèmes d'Information et du Numérique</strong></span></span></h1></td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table width='100%' cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td align='center'><table width='20%' border='0' cellpadding='3'>
                                    <tbody>
                                      <tr>
                                        <td><a href='$facebook_url' target='_blank' style='text-decoration: none !important;'> <img src='$facebook_img' width='20' alt='Facebook' title='Facebook'> </a> </td>
                                        <td><a href='$twitter_url' target='_blank' style='text-decoration: none !important;'> <img src='$twitter_img' width='20' alt='Twitter' title='Twitter'> </a></td>
                                        <td><a href='$linkedin_url' target='_blank' style='text-decoration: none !important;'> <img src='$linkedin_img' width='20' alt='LinkedIn' title='LinkedIn'> </a></td>
                                      </tr>
                                    </tbody>
                                  </table> 
                                   <table align='center' cellpadding='5px' cellspacing='10px'> 
                                    <tbody>
                                     <tr> 
                                      <td align='center'>   </td> 
                                     </tr> 
                                    </tbody>
                                   </table> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       background-color: #f3f3f3;
                       border-top-width: 1px;
                       border-top-style: solid;
                       border-right-width: 1px;
                       border-right-style: solid;
                       border-bottom-width: 1px;
                       border-bottom-style: solid;
                       border-left-width: 1px;
                       border-left-style: solid;
                       border-color: #000;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr> 
                          <td class='full mobile-full-width' width='50%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 20px 20px;'> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='30' style='font-size:30px; line-height: 30px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h2 style='font-family: Arial;
        font-size: 20px;
        font-weight: 300;line-height: 20px;
        color: #a3231a;
        margin: 0;mso-line-height-rule: exactly;'><strong>Le mot de passe de votre compte ($usrname) va expirer dans $delays jours. </strong></h2> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='20' style='font-size:20px; line-height: 20px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <p style='color: #393939;
        font-size: 17px;
        font-family: Arial;line-height: 22px;text-align: left;
        margin: 0;mso-line-height-rule: exactly;'> 
                                    <br>
                                    Voici la procédure pour modifier votre mot de passe :
                                    <br>Appuyer sur les touches <strong>CTRL + ALT+ SUPPR<br></strong>. <br />
                                                                        
                                 </p> </td> 
                                </tr> 
                               </tbody>
                              </table>
                              <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                     border-collapse: separate;'> 
                                     <tbody>
                                      <tr> 
                                       <td align='center'> <img src='$clavier_img' width='250'> </td> 
                                      </tr> 
                                     </tbody>
                                    </table>
                                    <table width='100%' cellpadding='0' cellspacing='0'>
                                     <!--<![endif]--> 
                                     <tbody>
                                      <tr> 
                                       <td align='left'> <p style='color: #393939;
                                         font-size: 17px;
                                         font-family: Arial;line-height: 22px;text-align: left;
                                         margin: 0;mso-line-height-rule: exactly;'>
                                                                      <br>Puis de sélectionner <strong>modifier un mot de passe</strong>. <br />
                                                                                                          
                                                                   </p> </td> 
                                                                  </tr> 
                                                                 </tbody>
                                                                </table>
                                                                <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                                                       border-collapse: separate;'> 
                                                                       <tbody>
                                                                        <tr> 
                                                                         <td align='center'> <img src='$menumdp_img' width='300'> </td> 
                                                                        </tr> 
                                                                       </tbody>
                                                                      </table>
                                                                      <table width='100%' cellpadding='0' cellspacing='0'>
                                                                       <!--<![endif]--> 
                                                                       <tbody>
                                                                        <tr> 
                                                                         <td align='left'> <p style='color: #393939;
                                                                           font-size: 17px;
                                                                           font-family: Arial;line-height: 22px;text-align: left;
                                                                           margin: 0;mso-line-height-rule: exactly;'>Dans la fenêtre suivante :
                                                                                                        <br>   - Saisir votre nom d'utilisateur si ce n'est pas déjà fait.
                                                                                                        <br>   - Saisir votre mot de passe actuel.
                                                                                                        <br>   - Définir un nouveau mot de passe d'un minimum de 12 caractères et de 3 jeux de caractères différents.
                                                                                                        <br>   - Confirmer le nouveau mot de passe<br><br />
                                                                                                                                            
                                                                                                     </p> </td> 
                                                                                                    </tr> 
                                                                                                   </tbody>
                                                                                                  </table>
                                                                                                  <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                                                                                         border-collapse: separate;'> 
                                                                                                         <tbody>
                                                                                                          <tr> 
                                                                                                           <td align='center'> <img src='$changemdp_img' width='400'> </td> 
                                                                                                          </tr> 
                                                                                                         </tbody>
                                                                                                        </table>
                                    <table width='100%' cellpadding='0' cellspacing='0'>
                                       <!--<![endif]--> 
                                       <tbody>
                                        <tr> 
                                         <td align='left'> <p style='color: #393939;
               font-size: 17px;
               font-family: Arial;line-height: 22px;text-align: left;
               margin: 0;mso-line-height-rule: exactly;'>
                                            <br>Pour vous accompagner lors du renouvellement , nous avons développé un générateur disponible ici :<br />
                                            
                                            <br />
                                         </p> </td> 
       
                                                       </tr> 
                                       </tbody>
                                      </table>
                                      </div>
                              <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style=''> 
                                     <tbody>
                                      <tr> 
                                       <td align='center'> <a href='$generateur_url' target='_blank' style='text-decoration: none !important;'> <img src='$generateur_img' width='270'> </a> </td> 
                                      </tr> 
                                     </tbody>
                                    </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='20' style='font-size:20px; line-height: 20px;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table>
                              
                           </td> 
                            </tr>
                            
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        '> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                        background-color: #e6e6e6;
                      border-color: #e65100;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 30px 30px 30px 30px;'> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> <h1 style='font-family: Arial;
       font-size: 20px;
       font-weight: normal;line-height: 20px;
       color: #393939;
       margin: 0;text-align: center;mso-line-height-rule: exactly;'><strong><span style='color: #a3231a;'><span style='color: #a3231a;'>Une fois votre mot de passe changé <br />
                                   nous vous conseillons de redémarrer&nbsp; la session <br />
                                   (ou de fermer et réouvrir la session)</span></span></strong></h1> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        '> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                        background-color: #fff;
                      border-top-width: 1px;
                      border-top-style: solid;
                      border-right-width: 1px;
                      border-right-style: solid;
                      border-bottom-width: 1px;
                      border-bottom-style: solid;
                      border-left-width: 1px;
                      border-left-style: solid;
                      border-color: #000;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='49.84615384615385%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 50px 20px 20px 20px;'> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='25' style='font-size:25px; line-height: 25px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='center'> <h2 style='font-family: Arial;
       font-size: 20px;
       font-weight: 300;line-height: 20px;
       color: #a3231a;
                   margin: 0;mso-line-height-rule: exactly;'><b>Important !<br />
                                 </b><br>
                                    N'oubliez de le modifier sur votre téléphone<br>
                                     pour ne pas verrouiller<br />
votre compte</h2> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='25' style='font-size:25px; line-height: 25px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> 
                                  <table align='left' cellpadding='0' cellspacing='0' border='0'> 
                                   <tbody>
                                    <tr> 
                                     <td style='padding: 0 10px 5px 0px;' class='fix-space-td-img'> 
                                      <div> 
                                       <img width='30' height='30' src='$wifi_img'> 
                                      </div> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 26px;text-align: left;
       margin: 0;mso-line-height-rule: exactly;'><span style='font-size: 14px; line-height: 26px; mso-line-height-rule: exactly;'>Modifier le mot de passe WIFI</span></p> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td align='center'> 
                                  <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                background-color:#d69311;
                border-collapse: separate;
                border: 1px solid #000;
                border-radius: 3px;'> 
                                   <tbody>
                                    <tr> 
                                     <td align='center' style='
                 padding: 5px 30px;
                 color: #fff;
                 font-family: Arial;
                 font-size: 15px;'> <a href='$wifi_notice' target='_blank' style='
                  text-align: center;
                  text-decoration: none;
                  display: block;
                  color: #fff;
                  font-family: Arial;
                  font-size: 15px;'> <span style='margin: 0px;'>Notice Wifi</span> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='27' style='font-size:27px; line-height: 27px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> 
                                  <table align='left' cellpadding='0' cellspacing='0' border='0'> 
                                   <tbody>
                                    <tr> 
                                     <td style='padding: 0 10px 5px 0px;' class='fix-space-td-img'> 
                                      <div> 
                                       <img width='30' height='30' src='$messagerie_img'> 
                                      </div> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 18px;text-align: left;
       margin: 0;mso-line-height-rule: exactly;'><span style='font-size: 14px; line-height: 18px; mso-line-height-rule: exactly;'>Modifier le mot de passe de la&nbsp; &nbsp; messagerie
                                    <br /><br />
                                  </span></p> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td align='center'> 
                                  <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                background-color:#a8231a;
                border-collapse: separate;
                border: 1px solid #080808;
                border-radius: 3px;'> 
                                   <tbody>
                                    <tr> 
                                     <td align='center' style='
                 padding: 5px 30px;
                 color: #fff;
                 font-family: Arial;
                 font-size: 15px;'> <a href='$messagerie_notice' target='_blank' style='
                  text-align: center;
                  text-decoration: none;
                  display: block;
                  color: #fff;
                  font-family: Arial;
                  font-size: 15px;'> <span style='margin: 0px;'>Notice messagerie</span> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='20' style='font-size:20px; line-height: 20px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                         <td class='full mobile-full-width' width='50.153846153846146%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 20px 20px 20px 20px;'> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td align='center'> 
                                  <table align='center' cellpadding='0' cellspacing='0'> 
                                   <tbody>
                                    <tr> 
                                     <td align='center' class='fix-space-td-img'> 
                                      <div> 
                                       <img style='display: block;' width='193' height='385' src='$smartphone_img'> 
                                      </div> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        '> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                        background-color: #e6e6e6;
                      border-color: #e65100;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 50px 50px 30px 50px;'> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> <h1 style='font-family: Arial;
       font-size: 30px;
       font-weight: normal;line-height: 40px;
       color: #393939;
       margin: 0;text-align: center;mso-line-height-rule: exactly;'>D'autres questions ?</h1> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 22px;text-align: center;
       margin: 0;mso-line-height-rule: exactly;'>Vous pouvez émettre une demande sur le catalogue de service <br />
                                   ou appeler le <strong>00.XX.XX.XX.XX</strong> option <strong>2</strong>. </p> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 26px;text-align: left;
       margin: 0;mso-line-height-rule: exactly;'>&nbsp;</p> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        background-color: #fff;
'> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                      border-color: #e65100;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 20px 20px 20px 20px;'> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> </td> 
       </tr> 
      </tbody>
     </table> </td> 
   </tr> 
  </tbody>
 </table>
 <table width='100%' border='0' cellspacing='0' cellpadding='0'>
  <tbody>
   <tr>
    <td></td>
   </tr>
  </tbody>
 </table>  
</body>
</html>"

               Send-SMTPmail -to $($usrmail) -from $MSender -subject $MSubject -cc $MSender_final -smtpserver $MServer -body $Mbody -html
            write-host "15jours envoie" $user.mail
            }
        elseif ($difference.Days -eq 3)
        {
               $MSubject = "Votre mot de passe expire dans 3 jours."
               $Mbody = ""

               Send-SMTPmail -to $($usrmail) -from $MSender -subject $MSubject -cc $MSender_final -smtpserver $MServer -body $Mbody -html
            write-host "3jours envoie" $user.mail
            }
            elseif ($difference.Days -eq 2)
            {
               $MSubject = "Votre mot de passe expire dans 2 jours."
               #2jours mails
               $Mbody ="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml' xmlns:v='urn:schemas-microsoft-com:vml' xmlns:o='urn:schemas-microsoft-com:office:office'>
 <head> 
  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'> 
  <meta name='viewport' content='width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1'> 
  <style type='text/css'>
    body {
      width: 100% !important;
      height: 100% !important;
      margin: 0;
      padding: 0;
    }
    html, body, div, span, applet, object, iframe,
    h1, h2, h3, h4, h5, h6, p, blockquote, pre,
    a, abbr, acronym, address, big, cite, code,
    del, dfn, em, img, ins, kbd, q, s, samp,
    small, strike, strong, sub, sup, tt, var,
    b, u, i, center,
    dl, dt, dd, ol, ul, li,
    fieldset, form, label, legend,
    table, caption, tbody, tfoot, thead, tr, th, td,
    article, aside, canvas, details, embed,
    figure, figcaption, footer, header, hgroup,
    menu, nav, output, ruby, section, summary,
    time, mark, audio, video {
      Margin: 0;
      padding: 0;
      border: 0;
    }
    article, aside, details, figcaption, figure,
    footer, header, hgroup, menu, nav, section {
      display: block;
    }
    body {
      line-height: 1;
    }
    blockquote, q {
      quotes: none;
    }
    blockquote:before, blockquote:after,
    q:before, q:after {
      content: '';
      content: none;
    }
    table {
      border-collapse: collapse;
      border-spacing: 0;
    }
    table, td {
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
    }
    .fix-space-td-img {
      font-size:0px;
      line-height:0px;
    }
    .fixed-table-layout {
      table-layout: fixed;
    }
    @media only screen and (max-width: 479px), only screen and (max-device-width: 479px) {
      .hidebloc {
        display: none !important;
      }
      body {
        width: auto !important;
      }
      #conteneur {
        width: 100% !important;
      }
      .full {
        display: block !important;
      }
      .mobile-full-width {
        width: 100% !important;
      }
      td.full {
        display: block !important;
      }
      img {
        max-width: 100% !important;
        height: auto !important;
      }
    }
  </style> 
  <title></title> 
  </head> 
 <body id='conteneur' style='width:100%; word-wrap: break-word;
        word-break: break-word; overflow-wrap: break-word;'> 
  <table id='content_root' width='100%' cellpadding='0' cellspacing='0' style='background-color:#fff;
'> 
   <tbody>
    <tr> 
     <td align='center'> 
      <table cellpadding='0' cellspacing='0' align='center'> 
       <tbody>
        <tr> 
         <td align='left' valign='top'> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         background-color: #fff;
'> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       border-color: #e65100;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 5px 20px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       background-color: #ffffff;
                       border-top-width: 1px;
                       border-top-style: solid;
                       border-right-width: 1px;
                       border-right-style: solid;
                       border-bottom-width: 1px;
                       border-left-width: 1px;
                       border-left-style: solid;
                       border-color: #000;
                     
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%' background='' style='background-image: url(''); background-position: center top; background-size:cover;'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr>
                              <table width='100%' cellpadding='0' cellspacing='0'>
                                <td align='center'> 
                                  <table align='center' cellpadding='0' cellspacing='0'> 
                                   <tbody>
                                    <tr> 
                                      <td align='left'> <a href='$site_web' target='_blank' style='text-decoration: none !important;'> <img src='$logo_img' width='250'> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td>
                                <tbody>
                                 <tr>                                     
                              <td align='center' style='
            padding: 0px 0px 0px 0px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h1 style='font-family: Arial;
        font-size: 30px;
        font-weight: normal;line-height: 40px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'><span style='font-size: 27px; font-family: Lobster, cursive; color: #ffffff; line-height: 40px; mso-line-height-rule: exactly;'><span style='color: #ffffff;'></span></span></h1> <h1 style='font-family: Arial;
        font-size: 20px;
        font-weight: normal;line-height: 40px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'><span style='font-size: 19px; font-family: verdana , cursive; bold; color: #ffffff; line-height: 40px; mso-line-height-rule: exactly;'><span style='color: #2c303b;'><strong>Direction des Systèmes d'Information et du Numérique</strong></span></span></h1></td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table width='100%' cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td align='center'><table width='20%' border='0' cellpadding='3'>
                                    <tbody>
                                      <tr>
                                        <td><a href='$facebook_url' target='_blank' style='text-decoration: none !important;'> <img src='$facebook_img' width='20' alt='Facebook' title='Facebook'> </a> </td>
                                        <td><a href='$twitter_url' target='_blank' style='text-decoration: none !important;'> <img src='$twitter_img' width='20' alt='Twitter' title='Twitter'> </a></td>
                                        <td><a href='$linkedin_url' target='_blank' style='text-decoration: none !important;'> <img src='$linkedin_img' width='20' alt='LinkedIn' title='LinkedIn'> </a></td>
                                      </tr>
                                    </tbody>
                                  </table> 
                                   <table align='center' cellpadding='5px' cellspacing='10px'> 
                                    <tbody>
                                     <tr> 
                                      <td align='center'>   </td> 
                                     </tr> 
                                    </tbody>
                                   </table> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       background-color: #f3f3f3;
                       border-top-width: 1px;
                       border-top-style: solid;
                       border-right-width: 1px;
                       border-right-style: solid;
                       border-bottom-width: 1px;
                       border-bottom-style: solid;
                       border-left-width: 1px;
                       border-left-style: solid;
                       border-color: #000;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr> 
                          <td class='full mobile-full-width' width='50%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 20px 20px;'> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='30' style='font-size:30px; line-height: 30px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h2 style='font-family: Arial;
        font-size: 20px;
        font-weight: 300;line-height: 20px;
        color: #a3231a;
        margin: 0;mso-line-height-rule: exactly;'><strong>Le mot de passe de votre compte ($usrname) va expirer dans $delays jours. </strong></h2> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='20' style='font-size:20px; line-height: 20px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <p style='color: #393939;
        font-size: 17px;
        font-family: Arial;line-height: 22px;text-align: left;
        margin: 0;mso-line-height-rule: exactly;'> 
                                    <br>
                                    Voici la procédure pour modifier votre mot de passe :
                                    <br>Appuyer sur les touches <strong>CTRL + ALT+ SUPPR<br></strong>. <br />
                                                                        
                                 </p> </td> 
                                </tr> 
                               </tbody>
                              </table>
                              <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                     border-collapse: separate;'> 
                                     <tbody>
                                      <tr> 
                                       <td align='center'> <img src='$clavier_img' width='250'> </td> 
                                      </tr> 
                                     </tbody>
                                    </table>
                                    <table width='100%' cellpadding='0' cellspacing='0'>
                                     <!--<![endif]--> 
                                     <tbody>
                                      <tr> 
                                       <td align='left'> <p style='color: #393939;
                                         font-size: 17px;
                                         font-family: Arial;line-height: 22px;text-align: left;
                                         margin: 0;mso-line-height-rule: exactly;'>
                                                                      <br>Puis de sélectionner <strong>modifier un mot de passe</strong>. <br />
                                                                                                          
                                                                   </p> </td> 
                                                                  </tr> 
                                                                 </tbody>
                                                                </table>
                                                                <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                                                       border-collapse: separate;'> 
                                                                       <tbody>
                                                                        <tr> 
                                                                         <td align='center'> <img src='$menumdp_img' width='300'> </td> 
                                                                        </tr> 
                                                                       </tbody>
                                                                      </table>
                                                                      <table width='100%' cellpadding='0' cellspacing='0'>
                                                                       <!--<![endif]--> 
                                                                       <tbody>
                                                                        <tr> 
                                                                         <td align='left'> <p style='color: #393939;
                                                                           font-size: 17px;
                                                                           font-family: Arial;line-height: 22px;text-align: left;
                                                                           margin: 0;mso-line-height-rule: exactly;'>Dans la fenêtre suivante :
                                                                                                        <br>   - Saisir votre nom d'utilisateur si ce n'est pas déjà fait.
                                                                                                        <br>   - Saisir votre mot de passe actuel.
                                                                                                        <br>   - Définir un nouveau mot de passe d'un minimum de 12 caractères et de 3 jeux de caractères différents.
                                                                                                        <br>   - Confirmer le nouveau mot de passe<br><br />
                                                                                                                                            
                                                                                                     </p> </td> 
                                                                                                    </tr> 
                                                                                                   </tbody>
                                                                                                  </table>
                                                                                                  <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                                                                                         border-collapse: separate;'> 
                                                                                                         <tbody>
                                                                                                          <tr> 
                                                                                                           <td align='center'> <img src='$changemdp_img' width='400'> </td> 
                                                                                                          </tr> 
                                                                                                         </tbody>
                                                                                                        </table>
                                    <table width='100%' cellpadding='0' cellspacing='0'>
                                       <!--<![endif]--> 
                                       <tbody>
                                        <tr> 
                                         <td align='left'> <p style='color: #393939;
               font-size: 17px;
               font-family: Arial;line-height: 22px;text-align: left;
               margin: 0;mso-line-height-rule: exactly;'>
                                            <br>Pour vous accompagner lors du renouvellement , nous avons développé un générateur disponible ici :<br />
                                            
                                            <br />
                                         </p> </td> 
       
                                                       </tr> 
                                       </tbody>
                                      </table>
                                      </div>
                              <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style=''> 
                                     <tbody>
                                      <tr> 
                                       <td align='center'> <a href='$generateur_url' target='_blank' style='text-decoration: none !important;'> <img src='$generateur_img' width='270'> </a> </td> 
                                      </tr> 
                                     </tbody>
                                    </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='20' style='font-size:20px; line-height: 20px;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table>
                              
                           </td> 
                            </tr>
                            
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        '> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                        background-color: #e6e6e6;
                      border-color: #e65100;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 30px 30px 30px 30px;'> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> <h1 style='font-family: Arial;
       font-size: 20px;
       font-weight: normal;line-height: 20px;
       color: #393939;
       margin: 0;text-align: center;mso-line-height-rule: exactly;'><strong><span style='color: #a3231a;'><span style='color: #a3231a;'>Une fois votre mot de passe changé <br />
                                   nous vous conseillons de redémarrer&nbsp; la session <br />
                                   (ou de fermer et réouvrir la session)</span></span></strong></h1> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        '> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                        background-color: #fff;
                      border-top-width: 1px;
                      border-top-style: solid;
                      border-right-width: 1px;
                      border-right-style: solid;
                      border-bottom-width: 1px;
                      border-bottom-style: solid;
                      border-left-width: 1px;
                      border-left-style: solid;
                      border-color: #000;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='49.84615384615385%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 50px 20px 20px 20px;'> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='25' style='font-size:25px; line-height: 25px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='center'> <h2 style='font-family: Arial;
       font-size: 20px;
       font-weight: 300;line-height: 20px;
       color: #a3231a;
                   margin: 0;mso-line-height-rule: exactly;'><b>Important !<br />
                                 </b><br>
                                    N'oubliez de le modifier sur votre téléphone<br>
                                     pour ne pas verrouiller<br />
votre compte</h2> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='25' style='font-size:25px; line-height: 25px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> 
                                  <table align='left' cellpadding='0' cellspacing='0' border='0'> 
                                   <tbody>
                                    <tr> 
                                     <td style='padding: 0 10px 5px 0px;' class='fix-space-td-img'> 
                                      <div> 
                                       <img width='30' height='30' src='$wifi_img'> 
                                      </div> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 26px;text-align: left;
       margin: 0;mso-line-height-rule: exactly;'><span style='font-size: 14px; line-height: 26px; mso-line-height-rule: exactly;'>Modifier le mot de passe WIFI</span></p> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td align='center'> 
                                  <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                background-color:#d69311;
                border-collapse: separate;
                border: 1px solid #000;
                border-radius: 3px;'> 
                                   <tbody>
                                    <tr> 
                                     <td align='center' style='
                 padding: 5px 30px;
                 color: #fff;
                 font-family: Arial;
                 font-size: 15px;'> <a href='$wifi_notice' target='_blank' style='
                  text-align: center;
                  text-decoration: none;
                  display: block;
                  color: #fff;
                  font-family: Arial;
                  font-size: 15px;'> <span style='margin: 0px;'>Notice Wifi</span> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='27' style='font-size:27px; line-height: 27px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> 
                                  <table align='left' cellpadding='0' cellspacing='0' border='0'> 
                                   <tbody>
                                    <tr> 
                                     <td style='padding: 0 10px 5px 0px;' class='fix-space-td-img'> 
                                      <div> 
                                       <img width='30' height='30' src='$messagerie_img'> 
                                      </div> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 18px;text-align: left;
       margin: 0;mso-line-height-rule: exactly;'><span style='font-size: 14px; line-height: 18px; mso-line-height-rule: exactly;'>Modifier le mot de passe de la&nbsp; &nbsp; messagerie
                                    <br /><br />
                                  </span></p> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td align='center'> 
                                  <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                background-color:#a8231a;
                border-collapse: separate;
                border: 1px solid #080808;
                border-radius: 3px;'> 
                                   <tbody>
                                    <tr> 
                                     <td align='center' style='
                 padding: 5px 30px;
                 color: #fff;
                 font-family: Arial;
                 font-size: 15px;'> <a href='$messagerie_notice' target='_blank' style='
                  text-align: center;
                  text-decoration: none;
                  display: block;
                  color: #fff;
                  font-family: Arial;
                  font-size: 15px;'> <span style='margin: 0px;'>Notice messagerie</span> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='20' style='font-size:20px; line-height: 20px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                         <td class='full mobile-full-width' width='50.153846153846146%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 20px 20px 20px 20px;'> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td align='center'> 
                                  <table align='center' cellpadding='0' cellspacing='0'> 
                                   <tbody>
                                    <tr> 
                                     <td align='center' class='fix-space-td-img'> 
                                      <div> 
                                       <img style='display: block;' width='193' height='385' src='$smartphone_img'> 
                                      </div> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        '> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                        background-color: #e6e6e6;
                      border-color: #e65100;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 50px 50px 30px 50px;'> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> <h1 style='font-family: Arial;
       font-size: 30px;
       font-weight: normal;line-height: 40px;
       color: #393939;
       margin: 0;text-align: center;mso-line-height-rule: exactly;'>D'autres questions ?</h1> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 22px;text-align: center;
       margin: 0;mso-line-height-rule: exactly;'>Vous pouvez émettre une demande sur le catalogue de service <br />
                                   ou appeler le <strong>00.XX.XX.XX.XX</strong> option <strong>2</strong>. </p> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 26px;text-align: left;
       margin: 0;mso-line-height-rule: exactly;'>&nbsp;</p> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        background-color: #fff;
'> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                      border-color: #e65100;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 20px 20px 20px 20px;'> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> </td> 
       </tr> 
      </tbody>
     </table> </td> 
   </tr> 
  </tbody>
 </table>
 <table width='100%' border='0' cellspacing='0' cellpadding='0'>
  <tbody>
   <tr>
    <td></td>
   </tr>
  </tbody>
 </table>  
</body>
</html>"

               Send-SMTPmail -to $($usrmail) -from $MSender -subject $MSubject -cc $MSender_final -smtpserver $MServer -body $Mbody -html
                        write-host "2jours envoie" $user.mail
            }
            elseif ($difference.Days -eq 1)
            {
                $MSubject = "Votre mot de passe expire dans 1 jour."
                # mail 1 jours
                $Mbody = "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml' xmlns:v='urn:schemas-microsoft-com:vml' xmlns:o='urn:schemas-microsoft-com:office:office'>
 <head> 
  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'> 
  <meta name='viewport' content='width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1'> 
  <style type='text/css'>
    body {
      width: 100% !important;
      height: 100% !important;
      margin: 0;
      padding: 0;
    }
    html, body, div, span, applet, object, iframe,
    h1, h2, h3, h4, h5, h6, p, blockquote, pre,
    a, abbr, acronym, address, big, cite, code,
    del, dfn, em, img, ins, kbd, q, s, samp,
    small, strike, strong, sub, sup, tt, var,
    b, u, i, center,
    dl, dt, dd, ol, ul, li,
    fieldset, form, label, legend,
    table, caption, tbody, tfoot, thead, tr, th, td,
    article, aside, canvas, details, embed,
    figure, figcaption, footer, header, hgroup,
    menu, nav, output, ruby, section, summary,
    time, mark, audio, video {
      Margin: 0;
      padding: 0;
      border: 0;
    }
    article, aside, details, figcaption, figure,
    footer, header, hgroup, menu, nav, section {
      display: block;
    }
    body {
      line-height: 1;
    }
    blockquote, q {
      quotes: none;
    }
    blockquote:before, blockquote:after,
    q:before, q:after {
      content: '';
      content: none;
    }
    table {
      border-collapse: collapse;
      border-spacing: 0;
    }
    table, td {
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
    }
    .fix-space-td-img {
      font-size:0px;
      line-height:0px;
    }
    .fixed-table-layout {
      table-layout: fixed;
    }
    @media only screen and (max-width: 479px), only screen and (max-device-width: 479px) {
      .hidebloc {
        display: none !important;
      }
      body {
        width: auto !important;
      }
      #conteneur {
        width: 100% !important;
      }
      .full {
        display: block !important;
      }
      .mobile-full-width {
        width: 100% !important;
      }
      td.full {
        display: block !important;
      }
      img {
        max-width: 100% !important;
        height: auto !important;
      }
    }
  </style> 
  <title></title> 
  </head> 
 <body id='conteneur' style='width:100%; word-wrap: break-word;
        word-break: break-word; overflow-wrap: break-word;'> 
  <table id='content_root' width='100%' cellpadding='0' cellspacing='0' style='background-color:#fff;
'> 
   <tbody>
    <tr> 
     <td align='center'> 
      <table cellpadding='0' cellspacing='0' align='center'> 
       <tbody>
        <tr> 
         <td align='left' valign='top'> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         background-color: #fff;
'> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       border-color: #e65100;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 5px 20px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       background-color: #ffffff;
                       border-top-width: 1px;
                       border-top-style: solid;
                       border-right-width: 1px;
                       border-right-style: solid;
                       border-bottom-width: 1px;
                       border-left-width: 1px;
                       border-left-style: solid;
                       border-color: #000;
                     
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%' background='' style='background-image: url(''); background-position: center top; background-size:cover;'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr>
                              <table width='100%' cellpadding='0' cellspacing='0'>
                                <td align='center'> 
                                  <table align='center' cellpadding='0' cellspacing='0'> 
                                   <tbody>
                                    <tr> 
                                      <td align='left'> <a href='$site_web' target='_blank' style='text-decoration: none !important;'> <img src='$logo_img' width='250'> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td>
                                <tbody>
                                 <tr>                                     
                              <td align='center' style='
            padding: 0px 0px 0px 0px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h1 style='font-family: Arial;
        font-size: 30px;
        font-weight: normal;line-height: 40px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'><span style='font-size: 27px; font-family: Lobster, cursive; color: #ffffff; line-height: 40px; mso-line-height-rule: exactly;'><span style='color: #ffffff;'></span></span></h1> <h1 style='font-family: Arial;
        font-size: 20px;
        font-weight: normal;line-height: 40px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'><span style='font-size: 19px; font-family: verdana , cursive; bold; color: #ffffff; line-height: 40px; mso-line-height-rule: exactly;'><span style='color: #2c303b;'><strong>Direction des Systèmes d'Information et du Numérique</strong></span></span></h1></td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table width='100%' cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td align='center'><table width='20%' border='0' cellpadding='3'>
                                    <tbody>
                                      <tr>
                                        <td><a href='$facebook_url' target='_blank' style='text-decoration: none !important;'> <img src='$facebook_img' width='20' alt='Facebook' title='Facebook'> </a> </td>
                                        <td><a href='$twitter_url' target='_blank' style='text-decoration: none !important;'> <img src='$twitter_img' width='20' alt='Twitter' title='Twitter'> </a></td>
                                        <td><a href='$linkedin_url' target='_blank' style='text-decoration: none !important;'> <img src='$linkedin_img' width='20' alt='LinkedIn' title='LinkedIn'> </a></td>
                                      </tr>
                                    </tbody>
                                  </table> 
                                   <table align='center' cellpadding='5px' cellspacing='10px'> 
                                    <tbody>
                                     <tr> 
                                      <td align='center'>   </td> 
                                     </tr> 
                                    </tbody>
                                   </table> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       background-color: #f3f3f3;
                       border-top-width: 1px;
                       border-top-style: solid;
                       border-right-width: 1px;
                       border-right-style: solid;
                       border-bottom-width: 1px;
                       border-bottom-style: solid;
                       border-left-width: 1px;
                       border-left-style: solid;
                       border-color: #000;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr> 
                          <td class='full mobile-full-width' width='50%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 20px 20px;'> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='30' style='font-size:30px; line-height: 30px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h2 style='font-family: Arial;
        font-size: 20px;
        font-weight: 300;line-height: 20px;
        color: #a3231a;
        margin: 0;mso-line-height-rule: exactly;'><strong>Le mot de passe de votre compte ($usrname) va expirer dans $delays jours. </strong></h2> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='20' style='font-size:20px; line-height: 20px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <p style='color: #393939;
        font-size: 17px;
        font-family: Arial;line-height: 22px;text-align: left;
        margin: 0;mso-line-height-rule: exactly;'> 
                                    <br>
                                    Voici la procédure pour modifier votre mot de passe :
                                    <br>Appuyer sur les touches <strong>CTRL + ALT+ SUPPR<br></strong>. <br />
                                                                        
                                 </p> </td> 
                                </tr> 
                               </tbody>
                              </table>
                              <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                     border-collapse: separate;'> 
                                     <tbody>
                                      <tr> 
                                       <td align='center'> <img src='$clavier_img' width='250'> </td> 
                                      </tr> 
                                     </tbody>
                                    </table>
                                    <table width='100%' cellpadding='0' cellspacing='0'>
                                     <!--<![endif]--> 
                                     <tbody>
                                      <tr> 
                                       <td align='left'> <p style='color: #393939;
                                         font-size: 17px;
                                         font-family: Arial;line-height: 22px;text-align: left;
                                         margin: 0;mso-line-height-rule: exactly;'>
                                                                      <br>Puis de sélectionner <strong>modifier un mot de passe</strong>. <br />
                                                                                                          
                                                                   </p> </td> 
                                                                  </tr> 
                                                                 </tbody>
                                                                </table>
                                                                <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                                                       border-collapse: separate;'> 
                                                                       <tbody>
                                                                        <tr> 
                                                                         <td align='center'> <img src='$menumdp_img' width='300'> </td> 
                                                                        </tr> 
                                                                       </tbody>
                                                                      </table>
                                                                      <table width='100%' cellpadding='0' cellspacing='0'>
                                                                       <!--<![endif]--> 
                                                                       <tbody>
                                                                        <tr> 
                                                                         <td align='left'> <p style='color: #393939;
                                                                           font-size: 17px;
                                                                           font-family: Arial;line-height: 22px;text-align: left;
                                                                           margin: 0;mso-line-height-rule: exactly;'>Dans la fenêtre suivante :
                                                                                                        <br>   - Saisir votre nom d'utilisateur si ce n'est pas déjà fait.
                                                                                                        <br>   - Saisir votre mot de passe actuel.
                                                                                                        <br>   - Définir un nouveau mot de passe d'un minimum de 12 caractères et de 3 jeux de caractères différents.
                                                                                                        <br>   - Confirmer le nouveau mot de passe<br><br />
                                                                                                                                            
                                                                                                     </p> </td> 
                                                                                                    </tr> 
                                                                                                   </tbody>
                                                                                                  </table>
                                                                                                  <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                                                                                         border-collapse: separate;'> 
                                                                                                         <tbody>
                                                                                                          <tr> 
                                                                                                           <td align='center'> <img src='$changemdp_img' width='400'> </td> 
                                                                                                          </tr> 
                                                                                                         </tbody>
                                                                                                        </table>
                                    <table width='100%' cellpadding='0' cellspacing='0'>
                                       <!--<![endif]--> 
                                       <tbody>
                                        <tr> 
                                         <td align='left'> <p style='color: #393939;
               font-size: 17px;
               font-family: Arial;line-height: 22px;text-align: left;
               margin: 0;mso-line-height-rule: exactly;'>
                                            <br>Pour vous accompagner lors du renouvellement , nous avons développé un générateur disponible ici :<br />
                                            
                                            <br />
                                         </p> </td> 
       
                                                       </tr> 
                                       </tbody>
                                      </table>
                                      </div>
                              <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style=''> 
                                     <tbody>
                                      <tr> 
                                       <td align='center'> <a href='$generateur_url' target='_blank' style='text-decoration: none !important;'> <img src='$generateur_img' width='270'> </a> </td> 
                                      </tr> 
                                     </tbody>
                                    </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='20' style='font-size:20px; line-height: 20px;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table>
                              
                           </td> 
                            </tr>
                            
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        '> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                        background-color: #e6e6e6;
                      border-color: #e65100;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 30px 30px 30px 30px;'> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> <h1 style='font-family: Arial;
       font-size: 20px;
       font-weight: normal;line-height: 20px;
       color: #393939;
       margin: 0;text-align: center;mso-line-height-rule: exactly;'><strong><span style='color: #a3231a;'><span style='color: #a3231a;'>Une fois votre mot de passe changé <br />
                                   nous vous conseillons de redémarrer&nbsp; la session <br />
                                   (ou de fermer et réouvrir la session)</span></span></strong></h1> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        '> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                        background-color: #fff;
                      border-top-width: 1px;
                      border-top-style: solid;
                      border-right-width: 1px;
                      border-right-style: solid;
                      border-bottom-width: 1px;
                      border-bottom-style: solid;
                      border-left-width: 1px;
                      border-left-style: solid;
                      border-color: #000;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='49.84615384615385%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 50px 20px 20px 20px;'> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='25' style='font-size:25px; line-height: 25px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='center'> <h2 style='font-family: Arial;
       font-size: 20px;
       font-weight: 300;line-height: 20px;
       color: #a3231a;
                   margin: 0;mso-line-height-rule: exactly;'><b>Important !<br />
                                 </b><br>
                                    N'oubliez de le modifier sur votre téléphone<br>
                                     pour ne pas verrouiller<br />
votre compte</h2> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='25' style='font-size:25px; line-height: 25px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> 
                                  <table align='left' cellpadding='0' cellspacing='0' border='0'> 
                                   <tbody>
                                    <tr> 
                                     <td style='padding: 0 10px 5px 0px;' class='fix-space-td-img'> 
                                      <div> 
                                       <img width='30' height='30' src='$wifi_img'> 
                                      </div> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 26px;text-align: left;
       margin: 0;mso-line-height-rule: exactly;'><span style='font-size: 14px; line-height: 26px; mso-line-height-rule: exactly;'>Modifier le mot de passe WIFI</span></p> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td align='center'> 
                                  <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                background-color:#d69311;
                border-collapse: separate;
                border: 1px solid #000;
                border-radius: 3px;'> 
                                   <tbody>
                                    <tr> 
                                     <td align='center' style='
                 padding: 5px 30px;
                 color: #fff;
                 font-family: Arial;
                 font-size: 15px;'> <a href='$wifi_notice' target='_blank' style='
                  text-align: center;
                  text-decoration: none;
                  display: block;
                  color: #fff;
                  font-family: Arial;
                  font-size: 15px;'> <span style='margin: 0px;'>Notice Wifi</span> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='27' style='font-size:27px; line-height: 27px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> 
                                  <table align='left' cellpadding='0' cellspacing='0' border='0'> 
                                   <tbody>
                                    <tr> 
                                     <td style='padding: 0 10px 5px 0px;' class='fix-space-td-img'> 
                                      <div> 
                                       <img width='30' height='30' src='$messagerie_img'> 
                                      </div> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 18px;text-align: left;
       margin: 0;mso-line-height-rule: exactly;'><span style='font-size: 14px; line-height: 18px; mso-line-height-rule: exactly;'>Modifier le mot de passe de la&nbsp; &nbsp; messagerie
                                    <br /><br />
                                  </span></p> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td align='center'> 
                                  <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                background-color:#a8231a;
                border-collapse: separate;
                border: 1px solid #080808;
                border-radius: 3px;'> 
                                   <tbody>
                                    <tr> 
                                     <td align='center' style='
                 padding: 5px 30px;
                 color: #fff;
                 font-family: Arial;
                 font-size: 15px;'> <a href='$messagerie_notice' target='_blank' style='
                  text-align: center;
                  text-decoration: none;
                  display: block;
                  color: #fff;
                  font-family: Arial;
                  font-size: 15px;'> <span style='margin: 0px;'>Notice messagerie</span> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td height='20' style='font-size:20px; line-height: 20px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                         <td class='full mobile-full-width' width='50.153846153846146%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 20px 20px 20px 20px;'> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               <tbody>
                                <tr> 
                                 <td align='center'> 
                                  <table align='center' cellpadding='0' cellspacing='0'> 
                                   <tbody>
                                    <tr> 
                                     <td align='center' class='fix-space-td-img'> 
                                      <div> 
                                       <img style='display: block;' width='193' height='385' src='$smartphone_img'> 
                                      </div> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        '> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                        background-color: #e6e6e6;
                      border-color: #e65100;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 50px 50px 30px 50px;'> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> <h1 style='font-family: Arial;
       font-size: 30px;
       font-weight: normal;line-height: 40px;
       color: #393939;
       margin: 0;text-align: center;mso-line-height-rule: exactly;'>D'autres questions ?</h1> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 22px;text-align: center;
       margin: 0;mso-line-height-rule: exactly;'>Vous pouvez émettre une demande sur le catalogue de service <br />
                                   ou appeler le <strong>00.XX.XX.XX.XX</strong> option <strong>2</strong>. </p> <p style='color: #393939;
       font-size: 17px;
       font-family: Arial;line-height: 26px;text-align: left;
       margin: 0;mso-line-height-rule: exactly;'>&nbsp;</p> </td> 
                                </tr> 
                               </tbody>
                              </table> 
                              <table width='100%' cellpadding='0' cellspacing='0'> 
                               </tbody>
                                  </table> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> 
         <div> 
          <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
        background-color: #fff;
'> 
           <tbody>
            <tr> 
             <td> 
              <table cellpadding='0' cellspacing='0'> 
               <tbody>
                <tr> 
                 <td align='center' width='650'> 
                  <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                      border-color: #e65100;
                    '> 
                   <tbody>
                    <tr> 
                     <td align='center'> 
                      <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                       <tbody>
                        <tr>
                         <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                          <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                           <tbody>
                            <tr> 
                             <td align='center' style='
           padding: 20px 20px 20px 20px;'> 
                              <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                              <!--[if !mso]><!-->
                              <table width='100%' cellpadding='0' cellspacing='0'>
                               <!--<![endif]--> 
                               <tbody>
                                <tr> 
                                 <td align='left'> </td> 
                                </tr> 
                               </tbody>
                              </table> </td> 
                            </tr> 
                           </tbody>
                          </table> </td> 
                        </tr>
                       </tbody>
                      </table> </td> 
                    </tr> 
                   </tbody>
                  </table> </td> 
                </tr> 
               </tbody>
              </table> </td> 
            </tr> 
           </tbody>
          </table> 
         </div> </td> 
       </tr> 
      </tbody>
     </table> </td> 
   </tr> 
  </tbody>
 </table>
 <table width='100%' border='0' cellspacing='0' cellpadding='0'>
  <tbody>
   <tr>
    <td></td>
   </tr>
  </tbody>
 </table>  
</body>
</html>"

                Send-SMTPmail -to $($usrmail) -from $MSender -subject $MSubject -cc $MSender_final -smtpserver $MServer -body $Mbody -html
            write-host "1jours envoie" $user.mail
            }
            elseif ($difference.Days -lt 1)
            {
                $MSubject = "Votre mot de passe est expiré."
                # mail 0 jours
                $Mbody = "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml' xmlns:v='urn:schemas-microsoft-com:vml' xmlns:o='urn:schemas-microsoft-com:office:office'>
 <head> 
  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'> 
  <meta name='viewport' content='width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1'> 
  <style type='text/css'>
    body {
      width: 100% !important;
      height: 100% !important;
      margin: 0;
      padding: 0;
    }
    html, body, div, span, applet, object, iframe,
    h1, h2, h3, h4, h5, h6, p, blockquote, pre,
    a, abbr, acronym, address, big, cite, code,
    del, dfn, em, img, ins, kbd, q, s, samp,
    small, strike, strong, sub, sup, tt, var,
    b, u, i, center,
    dl, dt, dd, ol, ul, li,
    fieldset, form, label, legend,
    table, caption, tbody, tfoot, thead, tr, th, td,
    article, aside, canvas, details, embed,
    figure, figcaption, footer, header, hgroup,
    menu, nav, output, ruby, section, summary,
    time, mark, audio, video {
      Margin: 0;
      padding: 0;
      border: 0;
    }
    article, aside, details, figcaption, figure,
    footer, header, hgroup, menu, nav, section {
      display: block;
    }
    body {
      line-height: 1;
    }
    blockquote, q {
      quotes: none;
    }
    blockquote:before, blockquote:after,
    q:before, q:after {
      content: '';
      content: none;
    }
    table {
      border-collapse: collapse;
      border-spacing: 0;
    }
    table, td {
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
    }
    .fix-space-td-img {
      font-size:0px;
      line-height:0px;
    }
    .fixed-table-layout {
      table-layout: fixed;
    }
    @media only screen and (max-width: 479px), only screen and (max-device-width: 479px) {
      .hidebloc {
        display: none !important;
      }
      body {
        width: auto !important;
      }
      #conteneur {
        width: 100% !important;
      }
      .full {
        display: block !important;
      }
      .mobile-full-width {
        width: 100% !important;
      }
      td.full {
        display: block !important;
      }
      img {
        max-width: 100% !important;
        height: auto !important;
      }
    }
  </style> 
  <title></title> 
 </head> 
 <body id='conteneur' style='width:100%; word-wrap: break-word;
        word-break: break-word; overflow-wrap: break-word;'> 
  <table id='content_root' width='100%' cellpadding='0' cellspacing='0' style='background-color:#fff;
'> 
   <tbody>
    <tr> 
     <td align='center'> 
      <table cellpadding='0' cellspacing='0' align='center'> 
       <tbody>
        <tr> 
         <td align='left' valign='top'> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         background-color: #fff;
'> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       border-color: #e65100;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 5px 20px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       background-color: #ffffff;
                       border-top-width: 1px;
                       border-top-style: solid;
                       border-right-width: 1px;
                       border-right-style: solid;
                       border-bottom-width: 1px;
                       border-left-width: 1px;
                       border-left-style: solid;
                       border-color: #000;
                     
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%' background='' style='background-image: url(''); background-position: center top; background-size:cover;'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr>
                              <table width='100%' cellpadding='0' cellspacing='0'>
                                <td align='center'> 
                                  <table align='center' cellpadding='0' cellspacing='0'> 
                                   <tbody>
                                    <tr> 
                                      <td align='left'> <a href='$site_web' target='_blank' style='text-decoration: none !important;'> <img src='$logo_img' width='250'> </a> </td> 
                                    </tr> 
                                   </tbody>
                                  </table> </td>
                                <tbody>
                                 <tr>                                     
                              <td align='center' style='
            padding: 0px 0px 0px 0px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h1 style='font-family: Arial;
        font-size: 30px;
        font-weight: normal;line-height: 40px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'><span style='font-size: 27px; font-family: Lobster, cursive; color: #ffffff; line-height: 40px; mso-line-height-rule: exactly;'><span style='color: #ffffff;'></span></span></h1> <h1 style='font-family: Arial;
        font-size: 20px;
        font-weight: normal;line-height: 40px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'><span style='font-size: 19px; font-family: verdana , cursive; bold; color: #ffffff; line-height: 40px; mso-line-height-rule: exactly;'><span style='color: #2c303b;'><strong>Direction des Systèmes d'Information et du Numérique</strong></span></span></h1></td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table width='100%' cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td align='center'><table width='20%' border='0' cellpadding='3'>
                                    <tbody>
                                      <tr>
                                        <td><a href='$facebook_url' target='_blank' style='text-decoration: none !important;'> <img src='$facebook_img' width='20' alt='Facebook' title='Facebook'> </a> </td>
                                        <td><a href='$twitter_url' target='_blank' style='text-decoration: none !important;'> <img src='$twitter_img' width='20' alt='Twitter' title='Twitter'> </a></td>
                                        <td><a href='$linkedin_url' target='_blank' style='text-decoration: none !important;'> <img src='$linkedin_img' width='20' alt='LinkedIn' title='LinkedIn'> </a></td>
                                      </tr>
                                    </tbody>
                                  </table> 
                                   <table align='center' cellpadding='5px' cellspacing='10px'> 
                                    <tbody>
                                     <tr> 
                                      <td align='center'>   </td> 
                                     </tr> 
                                    </tbody>
                                   </table> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       background-color: #f3f3f3;
                       border-top-width: 1px;
                       border-top-style: solid;
                       border-right-width: 1px;
                       border-right-style: solid;
                       border-bottom-width: 1px;
                       border-bottom-style: solid;
                       border-left-width: 1px;
                       border-left-style: solid;
                       border-color: #000;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr> 
                          <td class='full mobile-full-width' width='50%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 20px 20px;'> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='30' style='font-size:30px; line-height: 30px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h2 style='font-family: Arial;
        font-size: 20px;
        font-weight: 300;line-height: 20px;
        color: #a3231a;
        margin: 0;mso-line-height-rule: exactly;'><strong>Le mot de passe de votre compte ($usrname) est expiré. Vos accès sont donc limités ou bloqués. </strong></h2> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='20' style='font-size:20px; line-height: 20px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <p style='color: #393939;
        font-size: 17px;
        font-family: Arial;line-height: 22px;text-align: left;
        margin: 0;mso-line-height-rule: exactly;'> 
                                    <br>
                                     Voici la procédure pour modifier votre mot de passe si vous avez encore accès à votre session (<i>contactez le
                                     <strong>00.XX.XX.XX.XX</strong> option <strong>2</strong> en cas de problème.</i>):
                                     <br>Appuyer sur les touches <strong>CTRL + ALT+ SUPPR<br></strong>. <br />
                                                                         
                                  </p> </td> 
                                 </tr> 
                                </tbody>
                               </table>
                               <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                      border-collapse: separate;'> 
                                      <tbody>
                                       <tr> 
                                        <td align='center'> <img src='$clavier_img' width='250'> </td> 
                                       </tr> 
                                      </tbody>
                                     </table>
                                     <table width='100%' cellpadding='0' cellspacing='0'>
                                      <!--<![endif]--> 
                                      <tbody>
                                       <tr> 
                                        <td align='left'> <p style='color: #393939;
                                          font-size: 17px;
                                          font-family: Arial;line-height: 22px;text-align: left;
                                          margin: 0;mso-line-height-rule: exactly;'>
                                                                       <br>Puis de sélectionner <strong>modifier un mot de passe</strong>. <br />
                                                                                                           
                                                                    </p> </td> 
                                                                   </tr> 
                                                                  </tbody>
                                                                 </table>
                                                                 <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                                                        border-collapse: separate;'> 
                                                                        <tbody>
                                                                         <tr> 
                                                                          <td align='center'> <img src='$menumdp_img' width='300'> </td> 
                                                                         </tr> 
                                                                        </tbody>
                                                                       </table>
                                                                       <table width='100%' cellpadding='0' cellspacing='0'>
                                                                        <!--<![endif]--> 
                                                                        <tbody>
                                                                         <tr> 
                                                                          <td align='left'> <p style='color: #393939;
                                                                            font-size: 17px;
                                                                            font-family: Arial;line-height: 22px;text-align: left;
                                                                            margin: 0;mso-line-height-rule: exactly;'>Dans la fenêtre suivante :
                                                                                                         <br>   - Saisir votre nom d'utilisateur si ce n'est pas déjà fait.
                                                                                                         <br>   - Saisir votre mot de passe actuel.
                                                                                                         <br>   - Définir un nouveau mot de passe d'un minimum de 12 caractères et de 3 jeux de caractères différents.
                                                                                                         <br>   - Confirmer le nouveau mot de passe<br><br />
                                                                                                                                             
                                                                                                      </p> </td> 
                                                                                                     </tr> 
                                                                                                    </tbody>
                                                                                                   </table>
                                                                                                   <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                                                                                                          border-collapse: separate;'> 
                                                                                                          <tbody>
                                                                                                           <tr> 
                                                                                                            <td align='center'> <img src='$changemdp_img' width='400'> </td> 
                                                                                                           </tr> 
                                                                                                          </tbody>
                                                                                                         </table>
                                     <table width='100%' cellpadding='0' cellspacing='0'>
                                        <!--<![endif]--> 
                                        <tbody>
                                         <tr> 
                                          <td align='left'> <p style='color: #393939;
                font-size: 17px;
                font-family: Arial;line-height: 22px;text-align: left;
                margin: 0;mso-line-height-rule: exactly;'>
                                             <br>Pour vous accompagner lors du renouvellement , nous avons développé un générateur disponible ici :<br />
                                             
                                             <br />
                                          </p> </td> 
        
                                                        </tr> 
                                        </tbody>
                                       </table>
                                       </div>
                               <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style=''> 
                                      <tbody>
                                       <tr> 
                                        <td align='center'> <a href='$generateur_url' target='_blank' style='text-decoration: none !important;'> <img src='$generateur_img' width='270'> </a> </td> 
                                       </tr> 
                                      </tbody>
                                     </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='20' style='font-size:20px; line-height: 20px;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table>
                               
                            </td> 
                             </tr>
                             
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                         background-color: #e6e6e6;
                       border-color: #e65100;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 30px 30px 30px 30px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h1 style='font-family: Arial;
        font-size: 20px;
        font-weight: normal;line-height: 20px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'><strong><span style='color: #a3231a;'><span style='color: #a3231a;'>Une fois votre mot de passe changé <br />
                                    nous vous conseillons de redémarrer&nbsp; la session <br />
                                    (ou de fermer et réouvrir la session)</span></span></strong></h1> </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                         background-color: #fff;
                       border-top-width: 1px;
                       border-top-style: solid;
                       border-right-width: 1px;
                       border-right-style: solid;
                       border-bottom-width: 1px;
                       border-bottom-style: solid;
                       border-left-width: 1px;
                       border-left-style: solid;
                       border-color: #000;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='49.84615384615385%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 50px 20px 20px 20px;'> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='25' style='font-size:25px; line-height: 25px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='center'> <h2 style='font-family: Arial;
        font-size: 20px;
        font-weight: 300;line-height: 20px;
        color: #a3231a;
									  margin: 0;mso-line-height-rule: exactly;'><b>Important !<br />
                                  </b><br>
                                     N'oubliez de le modifier sur votre téléphone<br>
                                      pour ne pas verrouiller<br />
votre compte</h2> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='25' style='font-size:25px; line-height: 25px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> 
                                   <table align='left' cellpadding='0' cellspacing='0' border='0'> 
                                    <tbody>
                                     <tr> 
                                      <td style='padding: 0 10px 5px 0px;' class='fix-space-td-img'> 
                                       <div> 
                                        <img width='30' height='30' src='$wifi_img'> 
                                       </div> </td> 
                                     </tr> 
                                    </tbody>
                                   </table> <p style='color: #393939;
        font-size: 17px;
        font-family: Arial;line-height: 26px;text-align: left;
        margin: 0;mso-line-height-rule: exactly;'><span style='font-size: 14px; line-height: 26px; mso-line-height-rule: exactly;'>Modifier le mot de passe WIFI</span></p> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table width='100%' cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td align='center'> 
                                   <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                 background-color:#d69311;
                 border-collapse: separate;
                 border: 1px solid #000;
                 border-radius: 3px;'> 
                                    <tbody>
                                     <tr> 
                                      <td align='center' style='
                  padding: 5px 30px;
                  color: #fff;
                  font-family: Arial;
                  font-size: 15px;'> <a href='$wifi_notice' target='_blank' style='
                   text-align: center;
                   text-decoration: none;
                   display: block;
                   color: #fff;
                   font-family: Arial;
                   font-size: 15px;'> <span style='margin: 0px;'>Notice Wifi</span> </a> </td> 
                                     </tr> 
                                    </tbody>
                                   </table> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='27' style='font-size:27px; line-height: 27px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> 
                                   <table align='left' cellpadding='0' cellspacing='0' border='0'> 
                                    <tbody>
                                     <tr> 
                                      <td style='padding: 0 10px 5px 0px;' class='fix-space-td-img'> 
                                       <div> 
                                        <img width='30' height='30' src='$messagerie_img'> 
                                       </div> </td> 
                                     </tr> 
                                    </tbody>
                                   </table> <p style='color: #393939;
        font-size: 17px;
        font-family: Arial;line-height: 18px;text-align: left;
        margin: 0;mso-line-height-rule: exactly;'><span style='font-size: 14px; line-height: 18px; mso-line-height-rule: exactly;'>Modifier le mot de passe de la&nbsp; &nbsp; messagerie
                                     <br /><br />
                                   </span></p> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table width='100%' cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td align='center'> 
                                   <table border='0' align='center' class='mobile-full-width' cellpadding='0' cellspacing='0' style='
                 background-color:#a8231a;
                 border-collapse: separate;
                 border: 1px solid #080808;
                 border-radius: 3px;'> 
                                    <tbody>
                                     <tr> 
                                      <td align='center' style='
                  padding: 5px 30px;
                  color: #fff;
                  font-family: Arial;
                  font-size: 15px;'> <a href='$messagerie_notice' target='_blank' style='
                   text-align: center;
                   text-decoration: none;
                   display: block;
                   color: #fff;
                   font-family: Arial;
                   font-size: 15px;'> <span style='margin: 0px;'>Notice messagerie</span> </a> </td> 
                                     </tr> 
                                    </tbody>
                                   </table> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='10' style='font-size:10px; line-height: 10px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td height='20' style='font-size:20px; line-height: 20px; mso-line-height-rule:exactly;'>&nbsp;  </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                          <td class='full mobile-full-width' width='50.153846153846146%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 20px 20px;'> 
                               <table width='100%' cellpadding='0' cellspacing='0'> 
                                <tbody>
                                 <tr> 
                                  <td align='center'> 
                                   <table align='center' cellpadding='0' cellspacing='0'> 
                                    <tbody>
                                     <tr> 
                                      <td align='center' class='fix-space-td-img'> 
                                       <div> 
                                        <img style='display: block;' width='193' height='385' src='$smartphone_img'> 
                                       </div> </td> 
                                     </tr> 
                                    </tbody>
                                   </table> </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         '> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                         background-color: #e6e6e6;
                       border-color: #e65100;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 50px 50px 30px 50px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> <h1 style='font-family: Arial;
        font-size: 30px;
        font-weight: normal;line-height: 40px;
        color: #393939;
        margin: 0;text-align: center;mso-line-height-rule: exactly;'>D'autres questions ?</h1> <p style='color: #393939;
        font-size: 17px;
        font-family: Arial;line-height: 22px;text-align: center;
        margin: 0;mso-line-height-rule: exactly;'>Vous pouvez émettre une demande sur le catalogue de service <br />
                                    ou appeler le <strong>00.XX.XX.XX.XX</strong> option <strong>2</strong>. </p> <p style='color: #393939;
        font-size: 17px;
        font-family: Arial;line-height: 26px;text-align: left;
        margin: 0;mso-line-height-rule: exactly;'>&nbsp;</p> </td> 
                                 </tr> 
                                </tbody>
                               </table> 
                               <table width='100%' cellpadding='0' cellspacing='0'> 
                                </tbody>
                                   </table> </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> 
          <div> 
           <table class='structure-container' width='100%' cellpadding='0' cellspacing='0' style='
         background-color: #fff;
'> 
            <tbody>
             <tr> 
              <td> 
               <table cellpadding='0' cellspacing='0'> 
                <tbody>
                 <tr> 
                  <td align='center' width='650'> 
                   <table align='center' cellpadding='0' cellspacing='0' class='structure mobile-full-width' width='100%' style='
                       border-color: #e65100;
                     '> 
                    <tbody>
                     <tr> 
                      <td align='center'> 
                       <table align='center' class='mobile-full-width responsive fixed-table-layout' cellpadding='0' cellspacing='0' width='100%'> 
                        <tbody>
                         <tr>
                          <td class='full mobile-full-width' width='100%' valign='top' style='overflow:hidden;'> 
                           <table class='column' width='100%' cellpadding='0' cellspacing='0' style='margin: 0 auto; text-align: left;'> 
                            <tbody>
                             <tr> 
                              <td align='center' style='
            padding: 20px 20px 20px 20px;'> 
                               <!--[if mso]><table width='100%' cellpadding='0' cellspacing='0' align='left'><![endif]--> 
                               <!--[if !mso]><!-->
                               <table width='100%' cellpadding='0' cellspacing='0'>
                                <!--<![endif]--> 
                                <tbody>
                                 <tr> 
                                  <td align='left'> </td> 
                                 </tr> 
                                </tbody>
                               </table> </td> 
                             </tr> 
                            </tbody>
                           </table> </td> 
                         </tr>
                        </tbody>
                       </table> </td> 
                     </tr> 
                    </tbody>
                   </table> </td> 
                 </tr> 
                </tbody>
               </table> </td> 
             </tr> 
            </tbody>
           </table> 
          </div> </td> 
        </tr> 
       </tbody>
      </table> </td> 
    </tr> 
   </tbody>
  </table>
  <table width='100%' border='0' cellspacing='0' cellpadding='0'>
   <tbody>
    <tr>
     <td></td>
    </tr>
   </tbody>
  </table>  
 </body>
</html>"
                Send-SMTPmail -to $($usrmail) -from $MSender -subject $MSubject -cc $MSender_final -smtpserver $MServer -body $Mbody -html
            write-host "Expiration du mot de passe" $user.mail
            }
     }
}
     write-host "Nombre de compte concernée : " $Users.Count
