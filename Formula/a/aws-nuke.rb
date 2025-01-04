class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.41.0.tar.gz"
  sha256 "3f658dfc3d4595f519710f4e8dbb45746f5b775f7e3641aef7a8675475b017dd"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8b479a9ad679f03e4c4ab0a86ff180fa396c74594e35e08be494929254a9ea3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8b479a9ad679f03e4c4ab0a86ff180fa396c74594e35e08be494929254a9ea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8b479a9ad679f03e4c4ab0a86ff180fa396c74594e35e08be494929254a9ea3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e072233f3299ffc275c5afe804ccec03944d76b5f16f286fcd6d454e99c43f51"
    sha256 cellar: :any_skip_relocation, ventura:       "e072233f3299ffc275c5afe804ccec03944d76b5f16f286fcd6d454e99c43f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ebfdecfe69e52357d339b34eeef23536c6550bea12d8e25323800ce4fcb82b9"
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