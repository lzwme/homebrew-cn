class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "d2e76216161511217199c99b8921ab3273c147ba0eb6abf37ae7b04c563f6b6a"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0693cec0aa8e9125053a73a05772647dc02bac13bb6a83ca91f494312186db2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d27311ecadd0371a19039532df82b5950468a13919cfa80eacd022b0f974774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc79f41ae8621d37a5f05fe55513af218839584ba25f38c70a05547f8ea9623"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f35907b2347071db76b4e62d2d75b7cf2f2da62ae1d45436aec9af9598ccbe4"
    sha256 cellar: :any,                 arm64_linux:   "b94a481c9e016684aeaf28822117bf1f1ae2274327514a6afd804c0e91431a23"
    sha256 cellar: :any,                 x86_64_linux:  "b8c6e4d0f0db2c9c68ffc141e578c3cbfde94a31ac970bb534abba60cda2b6a6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end