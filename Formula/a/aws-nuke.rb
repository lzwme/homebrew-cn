class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.48.1.tar.gz"
  sha256 "810aa135f9fd81dcf967488989153e0ddc2cc3414102d30f44d2ae2c3e4a6717"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4abec2eaacbc3264778ce724c49646a6739c2f3ab830ac87f21b7580d24c7922"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4abec2eaacbc3264778ce724c49646a6739c2f3ab830ac87f21b7580d24c7922"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4abec2eaacbc3264778ce724c49646a6739c2f3ab830ac87f21b7580d24c7922"
    sha256 cellar: :any_skip_relocation, sonoma:        "eafb8085bf71393c2460f167649c1c043b82f625cf3f104a4e58503a292628b5"
    sha256 cellar: :any_skip_relocation, ventura:       "eafb8085bf71393c2460f167649c1c043b82f625cf3f104a4e58503a292628b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f33e34234e9336cf543f3ef4322fc939d1e5d01e5b56c4aa3c8a4702a7f6b1"
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