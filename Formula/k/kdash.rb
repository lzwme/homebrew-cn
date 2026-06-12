class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash.cli.rs/"
  url "https://ghfast.top/https://github.com/kdash-rs/kdash/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "2f856914fc2612857c880a0f2f76ecf458a845874a11c6d4bf6527155f96b44e"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3d0b504843778dce4d6116f257696ea1aae29bbb69514ea9c0ee9d09f68bdd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d233c78d9b52144453323be5cbb4d6852f493b9f1158ff74194fe9700bb3d63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e3622eac8ff5c068c2d49a4b5c515c756c83eedea02d0958cb7a1713d127670"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc1269dd5d033f414e37f6fe8247d327a9adef04d4835d5ad210aaff31800186"
    sha256 cellar: :any,                 arm64_linux:   "7ddc560e0c770f08e40dd8328d9db5be1d6cca6cc6371f67635a151edbab4bc4"
    sha256 cellar: :any,                 x86_64_linux:  "9c6574965ffb8f33e09bc9cc0d9f57a06fbb16bb3be73597dc84da8b9fa114ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    # failed with Linux CI, `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"kdash", [:out, :err] => output_log.to_s
      sleep 1
      output = output_log.read.gsub(%r{\e\[[\d;?]*[ -/]*[@-~]}, "")
      assert_match "Active Context", output
      assert_match "Resources", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end