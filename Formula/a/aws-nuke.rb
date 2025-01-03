class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.40.0.tar.gz"
  sha256 "e80a5d24c9fc39084442fae86739b4942f83382d03101934a3a0edbeecdfd3c4"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89ee68504b35bb6020da0c5c4b8603182a84f903372ea45f0bbfd8acf0dfe592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89ee68504b35bb6020da0c5c4b8603182a84f903372ea45f0bbfd8acf0dfe592"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89ee68504b35bb6020da0c5c4b8603182a84f903372ea45f0bbfd8acf0dfe592"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbc8b94c6f723ee0ddd0896dcd45d6083da9cb8cec9e01770dc49d17ba9f9934"
    sha256 cellar: :any_skip_relocation, ventura:       "fbc8b94c6f723ee0ddd0896dcd45d6083da9cb8cec9e01770dc49d17ba9f9934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "353d8d03b90f8fc9f856fa2d7725864d97d0980398467cd3d034ffc52a22781e"
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