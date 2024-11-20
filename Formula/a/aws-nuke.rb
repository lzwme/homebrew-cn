class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nuke.git",
      tag:      "v3.31.0",
      revision: "1ffd923ca1fefc74f04ae7f780aee47a3b4d7ec7"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11058a84e29712053deb5bbfd6f895d21d098a1b46d521c047dbfa37986a1ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11058a84e29712053deb5bbfd6f895d21d098a1b46d521c047dbfa37986a1ad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11058a84e29712053deb5bbfd6f895d21d098a1b46d521c047dbfa37986a1ad0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0869a997e4bb711bb853b454956728d12fc9c9c7c236168462e1a73d5f6718e"
    sha256 cellar: :any_skip_relocation, ventura:       "e0869a997e4bb711bb853b454956728d12fc9c9c7c236168462e1a73d5f6718e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad20f2c67c0676c6ef301a87728a19b5f2299edc6c85d837e0c5a6c02af732d"
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