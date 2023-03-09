class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.64.2.tar.gz"
  sha256 "5c07744aa4843ba98091a5d018a1ed3c167803882e9f2c9273fa118c7d95ecdd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "479d71462e56173bcd8c92faaff441cbbf3b1de3591c7b31a0abd9903d027e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ece945250ff11c19d9503aeaea91ad9b49b00fab85e3d075ea6be0ff04f3fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d7bf8a5319a64228e672857d74a1db691ee2b15b93dad47dede1dd326c843aa"
    sha256 cellar: :any_skip_relocation, ventura:        "01bc9e94075d84fbfff06a29b9c15f690c7b36077f4c05c06d5c127ceeba2186"
    sha256 cellar: :any_skip_relocation, monterey:       "17d5d99aa15f8c721183cee16a1a662350300ba96cfe5ccadec4771204d88dbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3291e23c35ccc8bbb6df4f897fb14835db680381ac985d7f01f72fc7d4101837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f7e4d6868e76ea24f61ae52800e44b622bef2a48f80c7b6773364dd9018ee70"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end