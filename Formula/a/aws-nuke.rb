class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.49.0.tar.gz"
  sha256 "512ff6f7e98155faad8243ba08d7149b067d8147c9704b07d8cc50bdb1a9b778"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c8102bc8e5f82aae82a10791dbd07323beb0945a7500ccd35e8bb191f9dafd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c8102bc8e5f82aae82a10791dbd07323beb0945a7500ccd35e8bb191f9dafd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c8102bc8e5f82aae82a10791dbd07323beb0945a7500ccd35e8bb191f9dafd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c03061f49aee865e1e98c8c3f12d4bf733dae26def2459e0f08b70c0abf458"
    sha256 cellar: :any_skip_relocation, ventura:       "c8c03061f49aee865e1e98c8c3f12d4bf733dae26def2459e0f08b70c0abf458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be5860e854ebd94a8dbc162023fc401873698da546157831c059a5ec2a91ffd2"
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