class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.15.5.tar.gz"
  sha256 "1030b255f3f64e63b8f9af287cc969f156240bf54ed6ec96523590d215a51da8"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ea5874d22517cdb0576801d273563064912a5265997ebfb12adff81fce44531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c954b5e37fc95ec24dd32bf4f6a10974142be3c6849098bf980b6e02489d6df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa5828fbf291fc92395b0ae7f0504f79ef8945b762def4b72ebb3214ade06531"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3b3d172647a01d0573686a35b47c6c7abdd3b865cb73514c085ac988521361e"
    sha256 cellar: :any_skip_relocation, ventura:       "3d1e653a7d8f1aa15c4e9c9af3dfa2f88492ff29e2b464685d86bdf2f664e22d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6fa4c43e85d1bed1fd688fa38308712f643a128c4ac9bf0d68abc8c1a1ea3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "871a03e6c1573d9be09d0881c2e70571789516ea745fad53cc0b134cef0eeb40"
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

    assert_match "Invalid account ID header",
      shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1")
  end
end