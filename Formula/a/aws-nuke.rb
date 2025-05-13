class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.52.2.tar.gz"
  sha256 "12de30844cd5729dd727c8e0e86b1fd3c0e69495ac488a34de52db82f9da96c6"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa3e55a029e151d156c726310cb77c56c5d97e94257cb34ef771d6fe1cfd536d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa3e55a029e151d156c726310cb77c56c5d97e94257cb34ef771d6fe1cfd536d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa3e55a029e151d156c726310cb77c56c5d97e94257cb34ef771d6fe1cfd536d"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d03df67cde6c9e0aaa843a543224195cccd9790550f4643d54eb9586056cb4"
    sha256 cellar: :any_skip_relocation, ventura:       "65d03df67cde6c9e0aaa843a543224195cccd9790550f4643d54eb9586056cb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da2220cc86c11b84ec49bcc59c6c745bc469b4c8130bb3d364a30ae6f6eec14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc1bda29462ac558231d84406ec17ca9cfe0a914a3f0efccf554893b2408c37e"
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