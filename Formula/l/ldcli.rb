class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "486e9e043d40e8186a1ae04b83eba30453d809b263a48e76d09f1d06c6fad013"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fabd02fb93318eb011f92476c019d7ca9ee1ddb0d6304473b80e98a2012569ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5392de0ac5ac95e9d62d6df4d870017c508b75ad0611c79d778641fce00f4d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59b720ea4699cfe36616d779068cae0489d0ef55b7ee22fb0163668d8e9db3f9"
    sha256 cellar: :any,                 arm64_linux:       "bc1a84f18d7381ad3c2607a1c5c56b8ca23aceeb1cd96164e61c2ce09bf00e14"
    sha256 cellar: :any,                 x86_64_linux:      "a905e01b3e6a4b928b175c09d409d79e254997858283653024c004b1fe0e8152"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end