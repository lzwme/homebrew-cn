class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.50.0.tar.gz"
  sha256 "8a1dfe06b41820081c1644c4db060caef1c2309cdb0abd9dcbeb49bc097974d1"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f975c41b6fb2d72c0e6df70a2c09c47494a1737f082adb9f708176512c30c24c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f975c41b6fb2d72c0e6df70a2c09c47494a1737f082adb9f708176512c30c24c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f975c41b6fb2d72c0e6df70a2c09c47494a1737f082adb9f708176512c30c24c"
    sha256 cellar: :any_skip_relocation, sonoma:        "31712507c80e442a657151aa6a5cd3e4dd43a70384a087c28c1108c94e7546e1"
    sha256 cellar: :any_skip_relocation, ventura:       "31712507c80e442a657151aa6a5cd3e4dd43a70384a087c28c1108c94e7546e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2cc7502a3846c82de4726d4dd039e385731e090420ad01f33180bf1b5ae27a4"
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