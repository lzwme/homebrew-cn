class Dasht < Formula
  desc "Search API docs offline, in your terminal or browser"
  homepage "https:sunaku.github.iodasht"
  url "https:github.comsunakudashtarchiverefstagsv2.4.0.tar.gz"
  sha256 "5ea43b0f7461e124d46b991892dedc8dcf506ccd5e9dc94324f7bdf6e580ff73"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "14af08c8719ce7e688faa8b061141624a912960bc57d53499161428f08820b21"
  end

  depends_on "socat"
  depends_on "sqlite"
  depends_on "w3m"
  depends_on "wget"

  def install
    bin.install Dir["bin*"]
    man.install "manman1"
  end

  test do
    system bin"dasht-docsets-install", "--force", "bash"
    assert_equal "Bash\n", shell_output(bin"dasht-docsets")
  end
end