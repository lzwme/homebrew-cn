class Auth0 < Formula
  desc "Build, manage and test your Auth0 integrations from the command-line"
  homepage "https://auth0.github.io/auth0-cli"
  url "https://ghfast.top/https://github.com/auth0/auth0-cli/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "af0d75fc51deed8ea3313bfa384b2ae55fdec21fbfe000bcb7f4e1d8a3e4980a"
  license "MIT"
  head "https://github.com/auth0/auth0-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8701aca992bb56c70f8d13d2168bacb78b43b4fb6870728df3a0c542c694c139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8701aca992bb56c70f8d13d2168bacb78b43b4fb6870728df3a0c542c694c139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8701aca992bb56c70f8d13d2168bacb78b43b4fb6870728df3a0c542c694c139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fa59ddb22ec39e896fbdf6792b961c78ba73aca7ecaabc7b1d9c79864fccf3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf0eb98b2f19be4d481d1b0aa6aa0797d99cbf381d15cab8e420acfa62f5a64"
  end

  depends_on "go" => :build

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