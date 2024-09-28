class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nuke.git",
      tag:      "v3.24.0",
      revision: "f4c02e9109101e61aecd433ae19f228f671c6104"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7643bb6d91aec545b499a15e2a036ef5b60cd5c20bda4e107219817e3cd39332"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7643bb6d91aec545b499a15e2a036ef5b60cd5c20bda4e107219817e3cd39332"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7643bb6d91aec545b499a15e2a036ef5b60cd5c20bda4e107219817e3cd39332"
    sha256 cellar: :any_skip_relocation, sonoma:        "21cebf183aab324c4bafc7416a50e3a5a5ce5726e273294b243e1547d12f8bcb"
    sha256 cellar: :any_skip_relocation, ventura:       "21cebf183aab324c4bafc7416a50e3a5a5ce5726e273294b243e1547d12f8bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f37df41a101bf74bdaf525c0fb96a4389823af7ae78d06d556ee3883add9aaf2"
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