class Auth0 < Formula
  desc "Build, manage and test your Auth0 integrations from the command-line"
  homepage "https://auth0.github.io/auth0-cli"
  url "https://ghfast.top/https://github.com/auth0/auth0-cli/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "ff870848255cbf21928d4888def78cc63a6dc65d9fa0e5286dc276228f8f13af"
  license "MIT"
  head "https://github.com/auth0/auth0-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4834b38955120becbe2dd21b2c551b8681723cd00951789327224f9cecba430"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4834b38955120becbe2dd21b2c551b8681723cd00951789327224f9cecba430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4834b38955120becbe2dd21b2c551b8681723cd00951789327224f9cecba430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99e56d2083c886640f148b19a9da21bc9be89fdfaafdd7b182a91d8b27337d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e466423bf95733bd130b9c611a97e1b7e424ec8b2c111d3ea5a83d7d41ffc40"
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