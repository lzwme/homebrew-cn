class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "24ece52c14437dd9d4b694022326b69c511f107ee0ad168bd5e7d366d8f10aa7"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e05378b07a5a43a0ffe88cf440f4dbb6d97cf3a777550b686d788fd49788b14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43295671d0ce17e9716f12eb3b07dc7a6865c965e3c910ab8f7b441199a00cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42b3382ba817f6c2bca67ad7697cc0f2b85a411019e5e7b743eb4ba9c19fd65d"
    sha256 cellar: :any_skip_relocation, sonoma:        "07f945183ad6cd9cbaea53e792796f80d11859731bc9cc297bf05c0144a81632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6d5184ddd94d6786fa8c76be54631be1990ba2847576af4b406aec123e9aa1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e128d7b92b03fb4086cb8de05e8071013464bebcd10e1ed33a90d78536160c7"
  end

  depends_on "rust" => :build

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