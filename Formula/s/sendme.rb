class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://ghfast.top/https://github.com/n0-computer/sendme/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "16ab2017a09bd584be4ae803dee7c71cea781eb63627abe6cae35f204775cccb"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80c3797ab7a22bc35253fd10e46e4d9fe1b29a7276a80347d9cc3c8726d0a80d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "727da2bc902b579733cbbbcacbfd8db34b9a19fabde65f3b77c3ba77d38e01cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b72565d19e6c5805ef2654d94083d6776a9b849318aed93f38d6e05a85649e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "279544879f149b6d89b82cef4615ce487293832643372d22fdf29af6534ad9a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b26343708fc877f88604884207edc28adcf6ef8a44716244666e0c926c1f765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c407160141bf16f3dfb7466a29363b3364877e0ee93da659c5c601c7390cdcd"
  end

  depends_on "rust" => :build

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