class Autopsy < Formula
  desc "Graphical interface to Sleuth Kit investigation tools"
  homepage "https:www.sleuthkit.orgautopsyindex.php"
  url "https:downloads.sourceforge.netprojectautopsyautopsy2.24autopsy-2.24.tar.gz"
  sha256 "ab787f519942783d43a561d12be0554587f11f22bc55ab79d34d8da703edc09e"

  livecheck do
    url "https:github.comsleuthkitautopsy.git"
    regex(autopsy[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b7daff147ae1d82a0dee7c5f3d853b0b6015af1bf2fde65f23676feae1b7895"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7daff147ae1d82a0dee7c5f3d853b0b6015af1bf2fde65f23676feae1b7895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "778ab6721c38acce97a7e7bbe7e4c941ecb9c8f6a684581e26d2b24684308046"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "778ab6721c38acce97a7e7bbe7e4c941ecb9c8f6a684581e26d2b24684308046"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd85ba9a96870da9470b8119649d1da48daa5bae273b0ef726535dac9dd4f5f0"
    sha256 cellar: :any_skip_relocation, ventura:        "fb630d6b19ab15e8688b7fe1b59bfd708dd6d0366cc9c29a40a33ecf6c9c4b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "cec5acab1fcc5e79f07962e85ed00af7696fb5db6d7e1bce164d8f21bf3b614d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cec5acab1fcc5e79f07962e85ed00af7696fb5db6d7e1bce164d8f21bf3b614d"
    sha256 cellar: :any_skip_relocation, catalina:       "cec5acab1fcc5e79f07962e85ed00af7696fb5db6d7e1bce164d8f21bf3b614d"
    sha256 cellar: :any_skip_relocation, mojave:         "cec5acab1fcc5e79f07962e85ed00af7696fb5db6d7e1bce164d8f21bf3b614d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1ce8b5147639d7737a4013030ee2a059d1b8dd4657554e08e9423a9a6b2f66"
  end

  depends_on "sleuthkit"

  uses_from_macos "perl"

  on_linux do
    depends_on "file-formula"
    depends_on "grep"
    depends_on "md5sha1sum"
  end

  # fixes weird configure script that wouldn't work nicely with homebrew
  patch :DATA

  def autcfg
    # Although these binaries are usually available on Linux, they can be in different locations
    # so we use the brewed versions instead.

    grep = "usrbingrep"
    file = "usrbinfile"
    md5 = "sbinmd5"
    sha1 = "usrbinshasum"

    on_linux do
      grep = Formula["grep"].opt_bin"grep"
      file = Formula["file"].opt_bin"file"
      md5 = Formula["md5sha1sum"].opt_bin"md5sum"
      sha1 = Formula["md5sha1sum"].opt_bin"sha1sum"
    end

    <<~EOS
      # Autopsy configuration settings

      # when set to 1, the server will stop after it receives no
      # connections for STIMEOUT seconds.
      $USE_STIMEOUT = 0;
      $STIMEOUT = 3600;

      # number of seconds that child waits for input from client
      $CTIMEOUT = 15;

      # set to 1 to save the cookie value in a file (for scripting)
      $SAVE_COOKIE = 1;

      $INSTALLDIR = '#{prefix}';


      # System Utilities
      $GREP_EXE = '#{grep}';
      $FILE_EXE = '#{file}';
      $MD5_EXE = '#{md5}';
      $SHA1_EXE = '#{sha1}';


      # Directories
      $TSKDIR = '#{Formula["sleuthkit"].opt_bin}';

      # Homebrew users can install NSRL database and change this variable later
      $NSRLDB = '';

      # Evidence locker location
      $LOCKDIR = '#{var}libautopsy';
    EOS
  end

  def install
    (var+"libautopsy").mkpath
    mv "lib", "libexec"
    prefix.install %w[global.css help libexec pict]
    prefix.install Dir["*.txt"]
    (prefix+"conf.pl").write autcfg
    inreplace "baseautopsy.base", "tmpautopsy", prefix
    inreplace "baseautopsy.base", "libdefine.pl", "#{libexec}define.pl"
    bin.install "baseautopsy.base" => "autopsy"
  end

  def caveats
    <<~EOS
      By default, the evidence locker is in:
        #{var}libautopsy
    EOS
  end

  test do
    # Launch autopsy inside a PTY and use Ctrl-C to exit it.
    PTY.spawn(bin"autopsy") do |_r, w, _pid|
      w.write "\cC"
    end
  end
end

__END__
diff --git abaseautopsy.base bbaseautopsy.base
index 3b3bbdc..a0d2632 100644
--- abaseautopsy.base
+++ bbaseautopsy.base
@@ -1,3 +1,6 @@
+#!usrbinperl -wT
+use lib 'tmpautopsy';
+use lib 'tmpautopsylibexec';
 #
 # autopsy gui server
 # Autopsy Forensic Browser