class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.35.3.tar.gz"
  sha256 "902a0b303cf9c240b8d077d3ae74ca55a4a8cd334961e56b4fa22d2c0d579041"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52b10ade462d4d9c00584070855d6078384ed1f2bd4d7aebd855b6ed3ffec868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b10ade462d4d9c00584070855d6078384ed1f2bd4d7aebd855b6ed3ffec868"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52b10ade462d4d9c00584070855d6078384ed1f2bd4d7aebd855b6ed3ffec868"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2776a1815dec1db80be800cf3729bc7ce78c4fa032714d0db74eba5067f4942"
    sha256 cellar: :any_skip_relocation, ventura:       "e2776a1815dec1db80be800cf3729bc7ce78c4fa032714d0db74eba5067f4942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e3a12fe4c2050c36f1171e8d0c73100bf8216625ceb964baa4a866cfa61dcb0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comekristenaws-nukev#{version.major}pkgcommon.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkgconfig"

    generate_completions_from_executable(bin"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}aws-nuke run --config #{pkgshare}configtestdataexample.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}aws-nuke resource-types")
  end
end