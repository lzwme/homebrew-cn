class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https:www.conftest.dev"
  url "https:github.comopen-policy-agentconftestarchiverefstagsv0.57.0.tar.gz"
  sha256 "6e85e66b550ad6ca9104f0dab47ba303c936b2d69b8e7e82806bd0723e242549"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentconftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77cf78eb8195d2ae9270646efd46820318ffc62eb9aae92d658d8b5704ad381"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c77cf78eb8195d2ae9270646efd46820318ffc62eb9aae92d658d8b5704ad381"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c77cf78eb8195d2ae9270646efd46820318ffc62eb9aae92d658d8b5704ad381"
    sha256 cellar: :any_skip_relocation, sonoma:        "a17d594316d44c5e738a37d3e7423b703000e61711ec2cb04711799f0de865a6"
    sha256 cellar: :any_skip_relocation, ventura:       "a17d594316d44c5e738a37d3e7423b703000e61711ec2cb04711799f0de865a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c0f102a002debc9bed1085dcfcac2f4361642acf8440a28a2c04a2e9db24ebf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comopen-policy-agentconftestinternalcommands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath"test.rego").write("package main")
    system bin"conftest", "verify", "-p", "test.rego"
  end
end