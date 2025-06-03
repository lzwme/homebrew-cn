class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.56.0.tar.gz"
  sha256 "a65e27f8ae32e6b923c498fe49eeaf191fdc919b92a636f0cf843b27cca57dad"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7702e4518ac85f6ef3fe4346c8fc1a6ccd6b1baf707694bd747a3ff1bacdab49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7702e4518ac85f6ef3fe4346c8fc1a6ccd6b1baf707694bd747a3ff1bacdab49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7702e4518ac85f6ef3fe4346c8fc1a6ccd6b1baf707694bd747a3ff1bacdab49"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd8919df942e11e4e971deaae12247ff1ed6631946ded3b3da5148b6cc37695a"
    sha256 cellar: :any_skip_relocation, ventura:       "dd8919df942e11e4e971deaae12247ff1ed6631946ded3b3da5148b6cc37695a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9908c9384b18d0681eefe823d1fa00a8425d5a0afc1a6222f72cba69d86ce6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "836a93147e0035fa991453b0d390a98aae3919d41eafd298f16912ee80a9cb9d"
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