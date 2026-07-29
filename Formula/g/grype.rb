class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.116.1.tar.gz"
  sha256 "e64bd796bc93092ac9af1955193903d37f33ffbd4667a64a6b97c8f0dc61a2a7"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba36764f83e4e06908467fc6eb8af04ee556499e59419cc67a5f146f2ddaa5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43cae3677c7b78c7796a1e3300e59a8f2b37d5676d7dfe67f63beebdeed354b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85a4457ae5f0e842bb4d96af6b2d67202a347c38a66eb603436b01bcb8450ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58b5f4b2cca5425d98080b38f30bb5a629d16d4c1d0fb6f32c74e9b21f7a47a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436c1abc44291e8e1594a983d938f4a7d0f226356a13c3724f625d9127435f59"
    sha256 cellar: :any,                 x86_64_linux:  "455ab44ce1783620b645906bee2b189afeb70184062479be1bd260b4ce514c5e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end