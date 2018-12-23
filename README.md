# fix_deviant_NIC————a shell can help your VPS restore network connecting from recovery by snapshot

Some IDC for example bandwagon or vultr will change NIC configuration after you make a snapshot and once you try to recovery from it, the server cannot connect to network, this shell can detective the real name of NIC and rewrite network interfaces.
<br />
<br />
To provent from this, you should download this shell before create a snapshot.
<br />
<br />
Useage:
<pre><code>wget https://git.io/fhJig -O fix_deviant_NIC.sh && bash fix_deviant_NIC.sh</code></pre>
