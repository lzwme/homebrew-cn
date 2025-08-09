class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.97.2.tar.gz"
  sha256 "bea921f3470e3d8db0552be8273112c0571d44828b202177dd52963d38eb6539"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0d014f45ab8d95fdf64af05b719b26393715debdd5816f09aa3dffdfc71864f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "878fbddab0147436733e4074ea5f51a4967269055787f3474494a47f7a618220"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c02a5b47c9d70bd5fa19a49413b2c1b015849b2fefde1039b15052160f0169b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8926cfcd59d3a0f2ad8d16df4efcc0c0ca537cb68aa7f8f600cfd992bfb6508f"
    sha256 cellar: :any_skip_relocation, ventura:       "c3a0c8d607e70fc28b155c0ad4964b558afd302145842f14e6763e2a3f3aa607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a426c01329c4022cf39b5db6e5f673bc974c6bf24bc11f48c66116f043803745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4cfc5974e80fcd65cf99f0bfdd576785d0b99b3fc01d284a72b33cc7dabdbd"
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