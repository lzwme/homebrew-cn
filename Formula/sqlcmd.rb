class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://ghproxy.com/https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "39b82d3ac2203039a5c3c706bcf41f81d641d74dd8c8bd494da8abd3e3a5f2e6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70366f618ac8d05ad78027a4463b0a8918a7e3cfbe6c654b3f3e24bbf2249071"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70366f618ac8d05ad78027a4463b0a8918a7e3cfbe6c654b3f3e24bbf2249071"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70366f618ac8d05ad78027a4463b0a8918a7e3cfbe6c654b3f3e24bbf2249071"
    sha256 cellar: :any_skip_relocation, ventura:        "ad5110ada1b1f971eb03adcac5e6e6a3b27cb26a79ae87eb304d6919329ad184"
    sha256 cellar: :any_skip_relocation, monterey:       "ad5110ada1b1f971eb03adcac5e6e6a3b27cb26a79ae87eb304d6919329ad184"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad5110ada1b1f971eb03adcac5e6e6a3b27cb26a79ae87eb304d6919329ad184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "385dc7f6e88c685a6179e497f7b909725e888f6747dab23c75c124cd327176a7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end