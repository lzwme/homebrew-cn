class Auth0 < Formula
  desc "Build, manage and test your Auth0 integrations from the command-line"
  homepage "https://auth0.github.io/auth0-cli"
  url "https://ghfast.top/https://github.com/auth0/auth0-cli/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "ec488eb214230568e4ae05fa04f6bf0db89869580ef9f97340eece20e8a3aa0e"
  license "MIT"
  head "https://github.com/auth0/auth0-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0c75955a77d7f4fc875133363fc66349ec9f93a26e1fef6a53628591487bfb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0c75955a77d7f4fc875133363fc66349ec9f93a26e1fef6a53628591487bfb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0c75955a77d7f4fc875133363fc66349ec9f93a26e1fef6a53628591487bfb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd12f109d82c816bacdea59300b818e34a31ec1a600efc4097f7b14c15f4769a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5d5a93af0d3ea2f4d12b6f9a9e5f06f3bc7dc65600a26fe724911bdfcd466348"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X github.com/auth0/auth0-cli/internal/buildinfo.Version=#{version}
      -X github.com/auth0/auth0-cli/internal/buildinfo.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/auth0"

    generate_completions_from_executable(bin/"auth0", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auth0 --version")

    # Without a tenant configured, the CLI exits non-zero with a clear message.
    output = shell_output("#{bin}/auth0 apps list 2>&1", 1)
    assert_match "Config.json file is missing", output
  end
end