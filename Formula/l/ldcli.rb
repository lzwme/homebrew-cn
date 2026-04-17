class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "294e2e125e3ea0f6f010805d730034ab0dbbfa4cdf5b0f175bb94da93e6b3773"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96b708009d21cb07f7f7c4d6e8af9e82c7765bd51616cace2fb8fa3097a7b93c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23025edc17ebc8d06841e1b4558c73ab61d925ec956faa5ce5a15155d7328ad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a7b8cb5f699f21fa294c044aa64fc33938376584242f72933b1635e17fdcc86"
    sha256 cellar: :any_skip_relocation, sonoma:        "906dbb0ae2ecb18c79effd1245fe246b06b4aafd146f6a60fb7a0009de8d48cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72831618addf451a82b1559070083e0cf065c07e108fd6d3d2e18e1068a00541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b4a9c31a59783c42418378036b3c6b25bfd5fae80de2704fbec9821470e1089"
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