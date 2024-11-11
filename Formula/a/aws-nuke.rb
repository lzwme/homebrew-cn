class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nuke.git",
      tag:      "v3.29.3",
      revision: "17d5f8ee40b3d8a575ebcfcbf6b7b36b4bbd0408"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40b699e722125ce33f8b355f5c28cc21c90bf2dc34c77bcdcd0cef8eac3817ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40b699e722125ce33f8b355f5c28cc21c90bf2dc34c77bcdcd0cef8eac3817ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40b699e722125ce33f8b355f5c28cc21c90bf2dc34c77bcdcd0cef8eac3817ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "752f859fcf6d010a1543364c70ae4e33bbea2546947017e320d544d5a740226e"
    sha256 cellar: :any_skip_relocation, ventura:       "752f859fcf6d010a1543364c70ae4e33bbea2546947017e320d544d5a740226e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79b56833dc21d8c03fa9ac1c03a3bff183e93d12a1cdb2bc370c52ec57c9f832"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.comekristenaws-nukev#{version.major}pkgcommon"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.SUMMARY=#{version}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:)
    end

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