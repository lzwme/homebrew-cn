class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.2.0",
      revision: "3ccbd659d78a9cec6d60f7b43e5bc093f453ed25"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a107d26f44535d77e409c39ad88344919dd80031765da65db8935d1b9971a761"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a107d26f44535d77e409c39ad88344919dd80031765da65db8935d1b9971a761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a107d26f44535d77e409c39ad88344919dd80031765da65db8935d1b9971a761"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0879f277a54a81218941767e8c3feabbf1b3f1f73e9608f46b2d70d5909789fd"
    sha256 cellar: :any,                 x86_64_linux:      "50587a870f742519af8004da2a95b91db9a28fe17468ceb3098bce7f4e43ae19"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end