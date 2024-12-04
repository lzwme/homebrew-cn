class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.34.0.tar.gz"
  sha256 "01da2bfbda59fb318dde4af278090a7066b4a93f19ec316abe0ad59ad5a214aa"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8328a06381ca104a275993dc52c9f0726f5ec54d33aa4c850d578c559e19aa53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8328a06381ca104a275993dc52c9f0726f5ec54d33aa4c850d578c559e19aa53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8328a06381ca104a275993dc52c9f0726f5ec54d33aa4c850d578c559e19aa53"
    sha256 cellar: :any_skip_relocation, sonoma:        "609acd82c5ca5c1130b8fc21384e141fd3a4870cee5a093dd659b53312f5df4b"
    sha256 cellar: :any_skip_relocation, ventura:       "609acd82c5ca5c1130b8fc21384e141fd3a4870cee5a093dd659b53312f5df4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "253f6a99567fa750cc6f2e13c3003e9a0141ab89dd3ec03b6182e42157965264"
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