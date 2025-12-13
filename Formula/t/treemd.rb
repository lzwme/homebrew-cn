class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "096b9f17a5801f7d2e1ab9ebc4dd4eb63e70d5f587a3dfe067fd53fef8cffb12"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "776eb27114b6248d5e501c49dfc412ebb1f9867befd799551f05cd27df772a91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f746dd099343c28d5a76e2cf158d33af959d4e660129c026baf13ff430846022"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "281a92a1174b9fc23d52c12d8bc4c512eaa5da8c0a0582dab703c5aa3f74516e"
    sha256 cellar: :any_skip_relocation, sonoma:        "28d31b543fc463836211651a65d8d9b817a8e26942d1904e836125f6cc7d7b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2d24253b986505fb733dfae024bac29997ad3ab58412ff924f6c06003e9ed7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41fc3234721ff04261ab4e39e89e7c4c74b394dc711a752aaf52873110c135a8"
  end

  depends_on "rust" => :build

  # Fix incorrect version number.
  # Remove in next release.
  patch do
    url "https://github.com/Epistates/treemd/commit/20525eaf5e31ec8df0935703c4845f06fb37c1fa.patch?full_index=1"
    sha256 "4ac9104f8527dd8293ff29b7ef31f85fad5c52775b27a5d78504b532a8ac18b7"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end