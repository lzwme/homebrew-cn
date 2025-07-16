class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.96.0.tar.gz"
  sha256 "c603223a6297414372f40588230a1e7baedc5d0478717a472cc2613d5afff2d3"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdbe615a7351eadb596066d169c8ca2961cb7f9873dd55e3abd5e0f7b03f61d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cead821c6cbe35e9ccce66053036b22935ceb775deb6edb54a3f4b8b834d0ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c381241d8d0ae596471af6316aa8d58f709a8feca1ddb582c81c4e72397d40a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "76e94e7e9e1c0a4c4d36f59d0e0a6d35f20a51ae6492da8103edea523ee49679"
    sha256 cellar: :any_skip_relocation, ventura:       "f4e807185af9605d7e775d1f392f3fa5a5865948b276d2dfe16c27c1e6ed6897"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da49c24a77e9a8bae6d91a7121b2fba97396e1b4472de5ca17dd5b0fc9bf6594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93867efb752b8e9081b98a3eb25b90412fad6fda3532c07bfbe9d4d0e6b5fc49"
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