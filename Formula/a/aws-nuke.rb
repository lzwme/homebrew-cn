class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.35.1.tar.gz"
  sha256 "defc7613790940179d54583c14e05e00d4b74e48d6d35a5d74cd55d609dc8b25"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05712bd8305226650883dfdf5ca94d8fcbae6184b82d5a85790e5d5755c6a424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05712bd8305226650883dfdf5ca94d8fcbae6184b82d5a85790e5d5755c6a424"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05712bd8305226650883dfdf5ca94d8fcbae6184b82d5a85790e5d5755c6a424"
    sha256 cellar: :any_skip_relocation, sonoma:        "86699f5f6cf03577cfabf47bb12dae159e3d87dd5ae018904e41a361d9246935"
    sha256 cellar: :any_skip_relocation, ventura:       "86699f5f6cf03577cfabf47bb12dae159e3d87dd5ae018904e41a361d9246935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af0bc3ed905fdb9bd87bdaf9cc12e60e873660d5caef990fa4b0b79d5d6ee668"
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