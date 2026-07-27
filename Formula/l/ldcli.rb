class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "cb4619bb8377d3b873a30681d01a3fec590c847dc359661b8ef9c3c98155be8e"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bf982e7a16097479a40e624c6d64404f9cd59132ca6b8c20e3c2152dc62bbe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d289ee71d05cef9d20056dfcf95b0d13ed402e0a6e431263fe77c86397b7747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee3b84269f265801388182d10426d5694f1949c2a87d5e6744837be1b1c0a52d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1ba10ff698d7a8a5b909ed1fa40b8333563ffafb0e80184e3e615896f26bee8"
    sha256 cellar: :any,                 arm64_linux:   "552b593faade9bd9ff1129eb1faf14c98e5d6fd67181120cae68371dede42fdc"
    sha256 cellar: :any,                 x86_64_linux:  "9bcee62eb6d9ebc58e7672982fd90331a8e14d7aa2912bb57ccbc9c0126927e0"
  end

  depends_on "go" => :build

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