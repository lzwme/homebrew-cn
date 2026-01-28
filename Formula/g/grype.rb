class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.106.0.tar.gz"
  sha256 "39da33b07886a5396681340c45fed80fbc67c3cc45048cdbf0f567f57e937c0f"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b4e267cb73aed3e63c6a0fae4f6d48684ecd126209c1698100de1bb91d019bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bb38de268623fa8d2c1c0cd5d3ea54e5949a00f7a3aea23830afbd16df1de4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edb997853ee8797e68423fd5b1176ff930eb7cc5726fa02a65b39337e5d4259d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b229d8059e45bfe21942cf161a7a811becdb67c2632b34c726c8e008df634d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8bf1235942b03a1258ac169f87dbe4daa644ee31b8dfc539d8cf57ef15f12ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "965a16437781e800efe67e45f283bd6b6cb1c0c90c79571b7e1fba75e7e2a0ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end