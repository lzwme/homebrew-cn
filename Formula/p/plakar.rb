class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://ghfast.top/https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "a6595524ad86f2fa4bb44f1ee724323d0d70b21ce2dc0417ce73d8a55ff1f647"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9ea6104ccf5ff990343022d48f96857f45b26c93d964283ba08034e8ce4472f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a340dc360555a523c60a5f4c4c3b1bccf580c6053bea9d23a25edcc56421301d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f362df4e94325f0bd7a61434db2af6d8f8e07a99c38873ff88e75baefee8ba2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47ebef95e96c4ca468c302e2b308ed9c0637a7b63634fe93d72d4f70861dea17"
    sha256 cellar: :any,                 x86_64_linux:      "6360e2e81b0891f7185a1f8e0d729bb0ba7c35389927d89f9eba9935f940b5cb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    ENV["PLAKAR_INSECURE_PLAINTEXT"] = "1"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end