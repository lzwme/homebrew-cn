class XdgNinja < Formula
  desc "Check your $HOME for unwanted files and directories"
  homepage "https:github.comb3nj5m1nxdg-ninja"
  url "https:github.comb3nj5m1nxdg-ninjaarchiverefstagsv0.2.0.2.tar.gz"
  sha256 "6adfe289821b6b5e3778130e0d1fd1851398e3bce51ddeed6c73e3eddcb806c6"
  license "MIT"
  head "https:github.comb3nj5m1nxdg-ninja.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "5d767e8e08cd29ca7a383288a46aa3ece6f66eefe8cdabeb103a3f882ededfb9"
  end

  depends_on "glow"
  depends_on "jq"

  def install
    pkgshare.install "programs"
    pkgshare.install "xdg-ninja.sh" => "xdg-ninja"
    (bin"xdg-ninja").write_env_script(pkgshare"xdg-ninja", XN_PROGRAMS_DIR: pkgshare"programs")
    man1.install "manxdg-ninja.1"
  end

  test do
    system bin"xdg-ninja"
  end
end