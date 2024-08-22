class Offlineimap < Formula
  include Language::Python::Virtualenv

  desc "Synchronizes emails between two repositories"
  homepage "https:github.comOfflineIMAPofflineimap3"
  url "https:github.comOfflineIMAPofflineimap3archiverefstagsv8.0.0.tar.gz"
  sha256 "5d40c163ca2fbf89658116e29f8fa75050d0c34c29619019eee1a84c90fcab32"
  license "GPL-2.0-or-later"
  revision 3
  head "https:github.comOfflineIMAPofflineimap3.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a4fb717f5c09554cff4835520465f3b87e5df6f5b2f7ba583a7690d661f9bc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ddee410fbb99b15f49fb1bef49ebe5b905ef36f6e58189962ee8ff3a93cb5b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de998456c60464b63904087546e5fed6194ac4dad9a3c2e6aaf32407a6daefc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf354b0b7e7611f540f2ae50a70cac4a150a087086a40522cd3ecb3d834ac657"
    sha256 cellar: :any_skip_relocation, ventura:        "2f8bc2f83bd2592c3c40b73be77d823eb8832ce7f42746e61c488294474a7c27"
    sha256 cellar: :any_skip_relocation, monterey:       "5edb2356ccc7b985e9c93dbdb55de133bcc33721f7d9727986b95caa3f981b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63baffe4fab72400e067ad56d8b0457ebfe54df5b6cf4a0f090c6c66d66243ca"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "krb5"

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "gssapi" do
    url "https:files.pythonhosted.orgpackages13e7dd88180cfcf243be62308707cc2f5dae4c726c68f30b9367931c794fda16gssapi-1.8.3.tar.gz"
    sha256 "aa3c8d0b1526f52559552bb2c9d2d6be013d76a8e5db00b39a1db5727e93b0b0"
  end

  resource "imaplib2" do
    url "https:files.pythonhosted.orgpackagese41a4ccb857f4832d2836a8c996f18fa7bcad19bfdf1a375dfa12e29dbe0e44aimaplib2-3.6.tar.gz"
    sha256 "96cb485b31868a242cb98d5c5dc67b39b22a6359f30316de536060488e581e5b"

    # Fix warnings with Python 3.12+.
    patch do
      url "https:github.comjazzbandimaplib2commitda0097f6b421c4b826416ea09b4802c163391330.patch?full_index=1"
      sha256 "ff60f720cfc61bfee9eec0af4d79d307e3a8703e575a19c18d05ef3477cf3a64"
    end
  end

  resource "portalocker" do
    url "https:files.pythonhosted.orgpackagesedd3c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "rfc6555" do
    url "https:files.pythonhosted.orgpackagesf64b24f953c3682c134e4d0f83c7be5ede44c6c653f7d2c0b06ebb3b117f005arfc6555-0.1.0.tar.gz"
    sha256 "123905b8f68e2bec0c15f321998a262b27e2eaadea29a28bd270021ada411b67"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages76d9bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01durllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  # Fix compatibility with Python 3.11+.
  patch do
    url "https:github.comOfflineIMAPofflineimap3commit7cd32cf834b34a3d4675b29bebcd32dc1e5ef128.patch?full_index=1"
    sha256 "ffddf6f43398ee13a761c78bece1b4262f9a46cc678966da6af2705ee0fbf1ba"
  end

  # Support python 3.12
  patch do
    url "https:github.comOfflineIMAPofflineimap3commitb0c75495db9e1b2b2879e7b0500a885df937bc66.patch?full_index=1"
    sha256 "6f22557b8d3bfabc9923e76ade72ac1d671c313b751980493f7f05619f57a8f9"
  end

  patch do
    url "https:github.comOfflineIMAPofflineimap3commita1951559299b297492b8454850fcfe6eb9822a38.patch?full_index=1"
    sha256 "64065e061d5efb1a416d43e9f6b776732d9b3b358ffcedafee76ca75abd782da"
  end

  patch do
    url "https:github.comOfflineIMAPofflineimap3commit4601f50d98cffcb182fddb04f8a78c795004bc73.patch?full_index=1"
    sha256 "a38595f54fa70d3cdb44aec2f858c256265421171a8ec331a34cbe6041072954"
  end

  # Fix warnings with Python 3.12+.
  # Adapted from: https:github.comOfflineIMAPofflineimap3commit489ff3bdb1fbd9b483b094f24936e7161f30a754
  patch :DATA

  def install
    virtualenv_install_with_resources

    etc.install "offlineimap.conf", "offlineimap.conf.minimal"
  end

  def caveats
    <<~EOS
      To get started, copy one of these configurations to ~.offlineimaprc:
      * minimal configuration:
          cp -n #{etc}offlineimap.conf.minimal ~.offlineimaprc

      * advanced configuration:
          cp -n #{etc}offlineimap.conf ~.offlineimaprc
    EOS
  end

  service do
    run [opt_bin"offlineimap", "-q", "-u", "basic"]
    run_type :interval
    interval 300
    environment_variables PATH: std_service_path_env
    log_path "devnull"
    error_log_path "devnull"
  end

  test do
    system bin"offlineimap", "--version"
  end
end

__END__
diff --git aofflineimapfolderBase.py bofflineimapfolderBase.py
index f871d6f..e798fb7 100644
--- aofflineimapfolderBase.py
+++ bofflineimapfolderBase.py
@@ -24,7 +24,6 @@ from sys import exc_info
 
 from email import policy
 from email.parser import BytesParser
-from email.generator import BytesGenerator
 from email.utils import parsedate_tz, mktime_tz
 
 from offlineimap import threadutil
@@ -249,7 +248,7 @@ class BaseFolder:
             basename = self.name.replace('', '.')
         # Replace with literal 'dot' if final path name is '.' as '.' is
         # an invalid file name.
-        basename = re.sub('(^|\)\.$', '\\1dot', basename)
+        basename = re.sub(r'(^|\)\.$', '\\1dot', basename)
         return basename
 
     def check_uidvalidity(self):
@@ -866,7 +865,7 @@ class BaseFolder:
         """
         msg_header = re.split(b'[\r]?\n[\r]?\n', raw_msg_bytes)[0]
         try:
-            msg_id = re.search(b"\nmessage-id:[\s]+(<[A-Za-z0-9!#$%&'*+-=?^_`{}|~.@ ]+>)", 
+            msg_id = re.search(br"\nmessage-id:[\s]+(<[A-Za-z0-9!#$%&'*+-=?^_`{}|~.@ ]+>)", 
                 msg_header, re.IGNORECASE).group(1)
         except AttributeError:
             # No match - Likely not following RFC rules.  Try and find anything
diff --git aofflineimapfolderGmail.py bofflineimapfolderGmail.py
index 544931a..c71720a 100644
--- aofflineimapfolderGmail.py
+++ bofflineimapfolderGmail.py
@@ -75,7 +75,7 @@ class GmailFolder(IMAPFolder):
 
         # Embed the labels into the message headers
         if self.synclabels:
-            m = re.search('X-GM-LABELS\s*[(](.*)[)]', data[0])
+            m = re.search(r'X-GM-LABELS\s*[(](.*)[)]', data[0])
             if m:
                 labels = set([imaputil.dequote(lb) for lb in imaputil.imapsplit(m.group(1))])
             else:
diff --git aofflineimapfolderIMAP.py bofflineimapfolderIMAP.py
index c9318c2..a2883a0 100644
--- aofflineimapfolderIMAP.py
+++ bofflineimapfolderIMAP.py
@@ -509,14 +509,14 @@ class IMAPFolder(BaseFolder):
                 item = [x.decode('utf-8') for x in item]
 
                 # Walk just tuples.
-                if re.search("(?:^|\\r|\\n)%s:\s*%s(?:\\r|\\n)" %
+                if re.search(r"(?:^|\\r|\\n)%s:\s*%s(?:\\r|\\n)" %
                              (headername, headervalue),
                              item[1], flags=re.IGNORECASE):
                     found = item[0]
             elif found is not None:
                 if isinstance(item, bytes):
                     item = item.decode('utf-8')
-                    uid = re.search("UID\s+(\d+)", item, flags=re.IGNORECASE)
+                    uid = re.search(r"UID\s+(\d+)", item, flags=re.IGNORECASE)
                     if uid:
                         return int(uid.group(1))
                     else:
@@ -526,7 +526,7 @@ class IMAPFolder(BaseFolder):
                         # ')'
                         # and item[0] stored in "found" is like:
                         # '1694 (UID 1694 RFC822.HEADER {1294}'
-                        uid = re.search("\d+\s+\(UID\s+(\d+)", found,
+                        uid = re.search(r"\d+\s+\(UID\s+(\d+)", found,
                                         flags=re.IGNORECASE)
                         if uid:
                             return int(uid.group(1))
diff --git aofflineimapfolderMaildir.py bofflineimapfolderMaildir.py
index f319b66..198927f 100644
--- aofflineimapfolderMaildir.py
+++ bofflineimapfolderMaildir.py
@@ -28,9 +28,9 @@ from .Base import BaseFolder
 from email.errors import NoBoundaryInMultipartDefect
 
 # Find the UID in a message filename
-re_uidmatch = re.compile(',U=(\d+)')
+re_uidmatch = re.compile(r',U=(\d+)')
 # Find a numeric timestamp in a string (filename prefix)
-re_timestampmatch = re.compile('(\d+)')
+re_timestampmatch = re.compile(r'(\d+)')
 
 timehash = {}
 timelock = Lock()
@@ -61,7 +61,7 @@ class MaildirFolder(BaseFolder):
             "Account " + self.accountname, "maildir-windows-compatible", False)
         self.infosep = '!' if self.wincompatible else ':'
         """infosep is the separator between maildir name and flag appendix"""
-        self.re_flagmatch = re.compile('%s2,(\w*)' % self.infosep)
+        self.re_flagmatch = re.compile(r'%s2,(\w*)' % self.infosep)
         # self.ui is set in BaseFolder.init()
         # Everything up to the first comma or colon (or ! if Windows):
         self.re_prefixmatch = re.compile('([^' + self.infosep + ',]*)')