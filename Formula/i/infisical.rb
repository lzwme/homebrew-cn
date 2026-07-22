class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.111.tar.gz"
  sha256 "fbe46763c2b6c75b3879644109dc76a9637ddb64de780544d434cd2fbf819f66"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c322f926987bc44a062ca6b01811a899d0f42cf6f16f39a386161fb78c4dc84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c322f926987bc44a062ca6b01811a899d0f42cf6f16f39a386161fb78c4dc84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c322f926987bc44a062ca6b01811a899d0f42cf6f16f39a386161fb78c4dc84"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd51ff1ba181819209d090db4d45a29d70f93b1ba71fdd58626f837a261d703d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2200152ead81517916cde339edf275948a5f2fa61d18dea13e36369d7488ac40"
    sha256 cellar: :any,                 x86_64_linux:  "a87649698b4a1a2edec93bd25ee28aad122999960e43b508bac29d869d24fb39"
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