class Ratty < Formula
  desc "GPU-rendered terminal emulator with inline 3D graphics"
  homepage "https://ratty-term.org/"
  url "https://ghfast.top/https://github.com/orhun/ratty/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "8d48b5c6adfc8543ed649a53221b61df129da415298c7875557c4fcb56255806"
  license "MIT"
  head "https://github.com/orhun/ratty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fd6635776b53756bcd13c5512415e8dc1ce29069bea7dd94e934e5e0535393c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97423c4a260dc0f05c9f6f23a51d754bb6094335a8816ee2d0d8d30eef1e2107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2525f37178b8a6c3cd16f795bfb95cc890398d89ed00ee16861ffc5936fb78af"
    sha256 cellar: :any_skip_relocation, sonoma:        "032d25d9f3ed9a251233a73325235c0ae93fc6b0a176d2a460d4f14472e30d8a"
    sha256 cellar: :any,                 arm64_linux:   "d74c9aa412d32d07a6f6681866145cf93bd662f8617b09e99f11357fc2f1263b"
    sha256 cellar: :any,                 x86_64_linux:  "7669079bd06314423212b9eaef9ecf8cb0c55a873b3ee65e53c7097a7311611c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "wayland"
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "config"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ratty --version")

    # No logs on Linux
    return if OS.linux?

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"ratty", [:out, :err] => output_log.to_s
      sleep 1
      expected = Hardware::CPU.arm? ? "Apple Paravirtual device" : "Unable to find a GPU"
      assert_match expected, output_log.read if OS.mac?
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end