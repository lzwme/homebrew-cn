class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https:launchdarkly.comdocshomegetting-startedldcli"
  url "https:github.comlaunchdarklyldcliarchiverefstagsv1.15.3.tar.gz"
  sha256 "0739727df8569c3be837def35a9ff02904e0b24591aabbc4f62a24f5c4993d27"
  license "Apache-2.0"
  head "https:github.comlaunchdarklyldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "641649c78d79f7ef2d6f7a69eb82eaec1e575002f3c315775101cd0c5ca5714c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80d80df78551298064a22c647541f5f7dbedfaa31a7a5a7c2b1e329a707af26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "964ac434235946fbc8845ca6149f36155428793747ea115ba840ebb675cf36df"
    sha256 cellar: :any_skip_relocation, sonoma:        "a38772c1dd6f6af380e43897e396908472881420571b2990ce1d5104501a10bd"
    sha256 cellar: :any_skip_relocation, ventura:       "5856accf4f9bd7ec17a34d7a5184f8b253e4fc0cd078432046210c80a4326b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50aff5979423a57fd0a0bbe1d4a84bd0e7347f3cf27ea2d7faad251d9d1bc5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f13544ef2d9b4c3bba419aadaacf4df17bb527428c49d15684d8abc3b74aba3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ldcli --version")

    assert_match "Invalid account ID header",
      shell_output("#{bin}ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1")
  end
end