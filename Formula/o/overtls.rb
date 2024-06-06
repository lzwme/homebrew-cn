class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.28.tar.gz"
  sha256 "a0e14b37bb3288f7157b72205524d60e617a943041b50dae895e3305fc96b2d3"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a9b0170ec37d79874bf148dddbeeb8eacd520d37d07493be451c1ceefe72a26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d552d1a140b675b0296b0f206594ee5c88c2e3b755ea469fdcce0e84a936b7d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99da8f1f4bf2236b9be93c78e0e8da8536bbdae42d51571b222f27de8ce605a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3e4426d42a660f95a4ff4cf82301910b3bcf596f517a80b55d6444902a14988"
    sha256 cellar: :any_skip_relocation, ventura:        "7288da82e0665ddf5aff4e3af94513d6dc85b6b4afb94a712b596b5f7869fca2"
    sha256 cellar: :any_skip_relocation, monterey:       "fe89918c302765487a187d0bbcbf67e4d407ccebfdd17ea67f01b1030f61e548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf05284ea5f31ee78141b6781947eaa8f1be6f4712fc5160c42fa1662b6333c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls -V")

    output = shell_output(bin"overtls -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end