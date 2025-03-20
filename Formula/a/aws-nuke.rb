class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.50.3.tar.gz"
  sha256 "5c673ff8df84ae9ef38160dc2d85fc21629408471fce2cb68c902af9220dc9e9"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d71f53c12e8509d20631812b7ffa5a07654954e9fe5dbf410c8c8d51af0f566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d71f53c12e8509d20631812b7ffa5a07654954e9fe5dbf410c8c8d51af0f566"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d71f53c12e8509d20631812b7ffa5a07654954e9fe5dbf410c8c8d51af0f566"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7f8bd7fb7a331048dee75f6a06772c22dc31928e255b65d6a3b812c9226168c"
    sha256 cellar: :any_skip_relocation, ventura:       "c7f8bd7fb7a331048dee75f6a06772c22dc31928e255b65d6a3b812c9226168c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2de7aacdd28f4ec7915092c81c1f38258c03cac2c67e6a4db12c0b2d09b3c31"
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