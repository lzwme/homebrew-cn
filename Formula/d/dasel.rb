class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghproxy.com/https://github.com/TomWright/dasel/archive/v2.3.5.tar.gz"
  sha256 "370c9973f5db765041b1bc688de2b738650db280122ba1428f2b27f376dfa991"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c159db7f1698c81379f413317c9f7e4fe4bb1e87b3b4732816f9de902da3d39e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa15b356f8a3a7faf2d219037ffd1264b18e11dacd401ca222c6b0d9732d8b34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98c6785d24dfd82e0779bd343f5db353278943bc17fe2e929bf18057f601b737"
    sha256 cellar: :any_skip_relocation, ventura:        "0877968101f0544ac695128698ed65708bff520826a80d8ed536ae372ae90c75"
    sha256 cellar: :any_skip_relocation, monterey:       "8558ee33b7542a84fe9f05fcfaa252a7dfba4142ce735241afc3d3f4741c6ea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ec42eebecf8ed2627281d102878b318294d69c42fca618f85b40c75d47a107a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abc71005f2fb97416c78da7b5f652cdc80c6ac606a071ed38527f115f9233db7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end