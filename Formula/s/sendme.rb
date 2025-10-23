class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://ghfast.top/https://github.com/n0-computer/sendme/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "8f1e7588d922904c4375e479a243c09c2fcbf8be3f01b9c67466f5569951b056"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afad3aa3eef6ca3d7aa6015ebd551181437f718f0bd39553f7712d74ef36c4c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfda80a25eb6704c626b982a8eae6d88a787b456f6d5cfcfba6b08c03edcb08d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "432026a5a5c31f823c3d3e117ebf6669e96ff664dc48c3a98f65b82581cafcd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f49cf5e46e3baad29e26e187acabc52e3b69066d17f279b64c2db3f2fc3498e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "739b2481cdf04966a4c023c844c2edadeb13e535128e92ac90dcfa1d20b9388b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b769b8d47e066e3375aa46c1016b847498704e588579b9374cf5024439b7f14"
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