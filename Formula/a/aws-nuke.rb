class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.54.0.tar.gz"
  sha256 "c47178ca467934bec1dd86a931aa0f8b88898678a14e717368be87c048800b8c"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b38e863cfcb050b0dee7d60cb2ada5952326f971dbb5d58def79e35e4681cda8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b38e863cfcb050b0dee7d60cb2ada5952326f971dbb5d58def79e35e4681cda8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b38e863cfcb050b0dee7d60cb2ada5952326f971dbb5d58def79e35e4681cda8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff5e801ce22aafb674f033b34c96491389c0bdbc899e6a92da24e1572e57ac25"
    sha256 cellar: :any_skip_relocation, ventura:       "ff5e801ce22aafb674f033b34c96491389c0bdbc899e6a92da24e1572e57ac25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2210f87dfeab151389a482c31ec69035505119fbc64812844e16a30ae60fb83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daca788780ee8282910fe6902303896d21968ac234726a40ef4501f1777f6735"
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