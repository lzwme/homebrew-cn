class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.31.tar.gz"
  sha256 "8ab19f4acb554337c0b0ae2b2b230f1752815f79cd09c35c224b62a9f5246ba3"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cad1534b634fa231325b03f1d31eb4fcb6b4489a108fe455204a365a55976088"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d2796cc4fe5e9674dfce49b56bbcee20a2efccebc6f0859e91a43f152f0d731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ae4989ae8a231392cc88cfd4457f00ea47d6030345a770cacfdb7e1b42be144"
    sha256 cellar: :any_skip_relocation, sonoma:         "583dbb927393f4e7d6a1e3605aadd5bc37c5a2df9bc2f439a30cb2bfeb427c25"
    sha256 cellar: :any_skip_relocation, ventura:        "565ece37a360c4262658fb179622bad7f128eff865f9169c70bbcb2beecfd573"
    sha256 cellar: :any_skip_relocation, monterey:       "d23dfe0ebea7ff4c4a1089f70655e82801a643e10b8d600cde910ecff2bce6ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec3318a8c8fde9f2138ff354055bb0dab108c235755317a274c14a00156bdcd0"
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