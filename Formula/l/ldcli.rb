class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.16.4.tar.gz"
  sha256 "9cb3429d6c47beb6152a0421c61379db48e5bbf37489ed1e7086d972fc567694"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d9400d7fa1266e2396103a1ecbc821e3e03400efc717a81cafd0cb0b9b13cfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3982ef1206c3e9404e1f7fee30571a9f433e0f6f668848f609570e24b0be7bc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a355a431e891bd5e28d12600176c6c694751a4e09cab9063cbea2ea64ace1c70"
    sha256 cellar: :any_skip_relocation, sonoma:        "d005b77eebcefa50503ab4a108e8520e7af96e83717687a969de48f96b45d894"
    sha256 cellar: :any_skip_relocation, ventura:       "079f7eb8d6d8753705ca0961a3b8f0e2d4fb1fa25db713a06c98162f2b9d6dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a958cd338f427fa3b9f65050c2629017fdb63cad671310dbd9d037f45fe4772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9028aff023671396c506470726cbb3d6ef47999bbee358d51f84f7f11f97df5f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end