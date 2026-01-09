class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.104.4.tar.gz"
  sha256 "7e2563dfda09fd5d8d5f51e4f1ae843bfd241ace50f9fadecf69a85a1bdcfb12"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58415442d82f67be53fb22eb1845fdd31613da82ec0031f6ef551dd6f0bd36ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "955d57f54fa4bbde5b616fa4a74c401e74b5c789a9d4bbfc281e6f0b03666ea2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa6ac86e8b42f15944d1fbce16c50a25014e0c6c19d25f930ebe4044b2a810b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "17a9ec0d82854c27d84bfc9a7d0ef29adc2bb413510f31ea82a41d95d23c07a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e30f0b314ad3de4a0bdd7ec77365db45135d669960369d8628095ddec64ed89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e3c582c8ab5e65e5db6fb92d7bdd6da5506ead3d29f7d090b9acd9fcb55d619"
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