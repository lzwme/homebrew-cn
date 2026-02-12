class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.53.tar.gz"
  sha256 "3f1f230e34e3d98fe64ffb314ee6734051c72237b54ab429fc8e042438feaad0"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ad85300db35c59183e08f667e1545890c9f868617f78a067d2a2895a8643be3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad85300db35c59183e08f667e1545890c9f868617f78a067d2a2895a8643be3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ad85300db35c59183e08f667e1545890c9f868617f78a067d2a2895a8643be3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e9bb033ca3442bddba885b5bdc083697421c723517c3f830bd3c3de28fe540a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "571755661c55cab5a3749c63c1d1b2140ba269e3ba61f39f0122aa6b9565b67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312235d329d7a4b9c272d97a51f74e40fa78b09b84ba6e98e49c19390d30166e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end