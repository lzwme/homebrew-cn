class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nuke.git",
      tag:      "v3.22.0",
      revision: "d76d6ef250a93df89721201fbc17eca71ff4f5db"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80f165c84a462b0a0c8b868e02f5d278210a62532961f638132a593b94f2f913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80f165c84a462b0a0c8b868e02f5d278210a62532961f638132a593b94f2f913"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80f165c84a462b0a0c8b868e02f5d278210a62532961f638132a593b94f2f913"
    sha256 cellar: :any_skip_relocation, sonoma:        "3919647ca45fe85feae26f88e26cbd31b64ddff533a9e22458a9ca7a810c5ad9"
    sha256 cellar: :any_skip_relocation, ventura:       "3919647ca45fe85feae26f88e26cbd31b64ddff533a9e22458a9ca7a810c5ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b1cce32d7208b9bd414de2c5509985e1d1c58d13502afd3d5bb7973085bedc"
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