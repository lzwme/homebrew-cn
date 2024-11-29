class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.33.0.tar.gz"
  sha256 "7b87180895c6c1729dbf803dfb90b2ca1d4ec9b92198e64cc6f1bc225965e6e1"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "009b690771a6a8388ddb41986932c34fb16424ece2fd8963781bb5eee0de95df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "009b690771a6a8388ddb41986932c34fb16424ece2fd8963781bb5eee0de95df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "009b690771a6a8388ddb41986932c34fb16424ece2fd8963781bb5eee0de95df"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf99f07c69dce750bb1f7e5f794414e01627b21802a72aa81eb83b7d2055f6fb"
    sha256 cellar: :any_skip_relocation, ventura:       "cf99f07c69dce750bb1f7e5f794414e01627b21802a72aa81eb83b7d2055f6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10e1330e35bbf45acdf2a464d0da13def9c4ba1624f9e2a1bfccb7ed4e02deda"
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