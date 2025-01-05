class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.42.0.tar.gz"
  sha256 "790437dab29c0808c6a4e4fc019ecd1ffa8e258257e553e85ed085119ba634ab"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94528d86565dad44f228786c0410e66b6b83a68bb6c2a32cc410fd2df1fb1af8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94528d86565dad44f228786c0410e66b6b83a68bb6c2a32cc410fd2df1fb1af8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94528d86565dad44f228786c0410e66b6b83a68bb6c2a32cc410fd2df1fb1af8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fb7609e18fc477fa98be9aea61c44bbaaea416ad802fff36196a963840bf2a0"
    sha256 cellar: :any_skip_relocation, ventura:       "7fb7609e18fc477fa98be9aea61c44bbaaea416ad802fff36196a963840bf2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e09a8239fe94dd887c7516c80beba72981dcc70b897d9adb91c6b8ff3fbc2540"
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