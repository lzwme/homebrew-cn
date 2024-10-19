class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nuke.git",
      tag:      "v3.29.0",
      revision: "4ca430c1fb0fe2270cfc6e32fa1b4dda2d4b7b0d"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c672021cc1bc6b60dba018cc2949579d468162e71e24a7b7329b8930eff7c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c672021cc1bc6b60dba018cc2949579d468162e71e24a7b7329b8930eff7c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c672021cc1bc6b60dba018cc2949579d468162e71e24a7b7329b8930eff7c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e3ba6e99dfa79533e8e39d3e9632f3baec89555aa84f7d14b48ec4731b0aefe"
    sha256 cellar: :any_skip_relocation, ventura:       "5e3ba6e99dfa79533e8e39d3e9632f3baec89555aa84f7d14b48ec4731b0aefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c41ae2b44f5e6522740b9b5111ec4d4767f0eecec2c57ff0913d4a4236e13813"
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