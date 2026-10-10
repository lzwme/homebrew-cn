class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://ghfast.top/https://github.com/n0-computer/sendme/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "46445440a25448de21f01f6d378314d8adca62d6f0cc10fb1577e66852c400f2"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bfe0e52643f9bcd9fafe0b024b505eb71c7dc479491fbe10fbd7ba3e3990a639"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78a3227583a31258475c8527c7a96b06ba13915a829fc73a6dc11bd6fc7caf57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1854ff36a82537788be816307f0ee92195047facc914054b2c9637f0394ac93f"
    sha256 cellar: :any,                 arm64_linux:       "43da14e12257d546d517ebfeabad2fe4125b731edafc106525a2e4946189407b"
    sha256 cellar: :any,                 x86_64_linux:      "455405fa36ba52bbfcbd70a9b2fa1eed259f27dedea33c978c0435e8fd948697"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sendme --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"sendme", "send", bin/"sendme", [:out, :err] => output_log.to_s
      sleep 4
      assert_match "imported file #{bin}/sendme", output_log.read
      assert_match "to get this data, use\nsendme receive", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end