class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.12.2",
      revision: "6191b1d0adab0dc0c8d8f416ffb1b98308714374"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a217567b212c15f0f4216224987c5d5301a0bbd7f9ceef9d04e9cf25c80ddd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a217567b212c15f0f4216224987c5d5301a0bbd7f9ceef9d04e9cf25c80ddd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a217567b212c15f0f4216224987c5d5301a0bbd7f9ceef9d04e9cf25c80ddd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "492d3c5298a472c663e1d246258970dae853187a4c93b49f4467e2d700dfa38d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d114a21b54db7114b8824ec7bbbf2ead5fcc7c286e8d7bd19bfbd0f223b6d202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6ab62f2cd8405d91ee725ff9a082ea8010a2258c9adbf59dd6d478041b30245"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end