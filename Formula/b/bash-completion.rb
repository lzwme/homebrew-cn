# NOTE: version 2 is out, but it requires Bash 4, and macOS ships
# with 3.2.57. If you've upgraded bash, use bash-completion@2 instead.
class BashCompletion < Formula
  desc "Programmable completion for Bash 3.2"
  homepage "https:salsa.debian.orgdebianbash-completion"
  url "https:src.fedoraproject.orgrepopkgsbash-completionbash-completion-1.3.tar.bz2a1262659b4bbf44dc9e59d034de505ecbash-completion-1.3.tar.bz2"
  sha256 "8ebe30579f0f3e1a521013bcdd183193605dab353d7a244ff2582fb3a36f7bec"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    skip "1.x versions are no longer developed"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6727e6e418e740531b75aebedaac6ceece0a0865f4f46dd0351d265035b497e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60e79daad9283c5e9f4c814eed837c86aab0b5172c633e7171cbbf26a434bcff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7902e07973d14daf1bf98d5e3bc5b84beeee977b943c33585cf86d4eaae6e36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7902e07973d14daf1bf98d5e3bc5b84beeee977b943c33585cf86d4eaae6e36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44be13e781914250b3c277ce3672b7a3c45974f80ae8a2b0c55ccf884faf5d6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "10c560f8c8058f80450a1d44826e57820d83370dbc3631cf5230a15cc8b8bbdc"
    sha256 cellar: :any_skip_relocation, ventura:        "1a5cc6b613a97f1a15f87725d8343b4358e56acaa230f7cec64c77d4566a6f80"
    sha256 cellar: :any_skip_relocation, monterey:       "1a5cc6b613a97f1a15f87725d8343b4358e56acaa230f7cec64c77d4566a6f80"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe573529e08174b26d4379d92a42a7c38138c712e4e998541e8892fc6a376e7"
    sha256 cellar: :any_skip_relocation, catalina:       "bd0c84cc6df9d3ff06ac081d85fdcc052b9e63136f4e2aa5fd2f2a0b7f654c84"
    sha256 cellar: :any_skip_relocation, mojave:         "9219c2b46362677e9ae6e19b344b774c3e9f163ae6bf6cf2686da06419aaec89"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b069be5574bdf6d12fd1fda17c3162467b68165541166d95d1a9474653a63abc"
    sha256 cellar: :any_skip_relocation, sierra:         "58be92ef01d5068f37b1c00af8e9b202bdb409c93121bb0e07dcbb5e55dc3be2"
    sha256 cellar: :any_skip_relocation, el_capitan:     "58be92ef01d5068f37b1c00af8e9b202bdb409c93121bb0e07dcbb5e55dc3be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c34ba8272f8e85e7f453c76e0fee07d8d35831e6b6365588a80ef240f9524e50"
  end

  on_linux do
    conflicts_with "util-linux", because: "both install `mount`, `rfkill`, and `rtcwake` completions"
  end

  conflicts_with "bash-completion@2", because: "each are different versions of the same formula"
  conflicts_with "medusa", because: "both install `medusa` bash completion"

  # Backports the following upstream patch from 2.x:
  # https:bugs.debian.orgcgi-binbugreport.cgi?bug=740971
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesc1d87451da3b5b147bed95b2dc783a1b02520ac5bash-completionbug-740971.patch"
    sha256 "bd242a35b8664c340add068bcfac74eada41ed26d52dc0f1b39eebe591c2ea97"
  end

  # Backports (a variant of) an upstream patch to fix man completion.
  patch :DATA

  def install
    inreplace "bash_completion" do |s|
      s.gsub! "etcbash_completion", etc"bash_completion"
      s.gsub! "readlink -f", "readlink"
    end

    system ".configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    s = <<~EOS
      Add the following line to your ~.bash_profile:
        [[ -r "#{etc}profile.dbash_completion.sh" ]] && . "#{etc}profile.dbash_completion.sh"
    EOS
    version_caveat = <<~EOS

      This formula is mainly for use with Bash 3. If you are using Homebrew's Bash or your
      system Bash is at least version 4.2, then you should install `bash-completion@2` instead.
    EOS
    if Formula["bash"].any_version_installed?
      s += version_caveat
    else
      on_linux do
        s += version_caveat
      end
    end
    s
  end

  test do
    system "bash", "-c", ". #{etc}profile.dbash_completion.sh"
  end
end

__END__
--- acompletionsman
+++ bcompletionsman
@@ -27,7 +27,7 @@
     fi

     uname=$( uname -s )
-    if [[ $uname == @(Linux|GNU|GNU*|FreeBSD|Cygwin|CYGWIN_*) ]]; then
+    if [[ $uname == @(Darwin|Linux|GNU|GNU*|FreeBSD|Cygwin|CYGWIN_*) ]]; then
         manpath=$( manpath 2>devnull || command man --path )
     else
         manpath=$MANPATH