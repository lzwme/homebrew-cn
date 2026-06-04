class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.113.0.tar.gz"
  sha256 "abd5547a5e5d9b01d93c51e3fdc6ad7319daf3cf150105f742f6fd33b7066c0d"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "315591a963906a543d11f2f65b0e39cee69eb65fb10257b7d520ccbef30eeee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b62b03a1124c3f622d311b538f55aafe52950b8f180d99aa9721c98db388644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "749239874caef2e12a48cc3ebcb3f568e14c551deafbc6e35dbf8f1b0edb68ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "f10885ff922e2f04ea1491b6cd2795b021f150b4e5bff66feea12ddccc51f277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb8303490e3c8dd2e96494aa373c5637dc37d8b296176b073f983f24fc0eea53"
    sha256 cellar: :any,                 x86_64_linux:  "cbe8d834afabba7efa9cd776a52bf61169ed5d4ec9b938a2725cbb2d9938f3f5"
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