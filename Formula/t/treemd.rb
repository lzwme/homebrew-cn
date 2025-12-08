class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "9186ea695bf9c63caa42bd83a4780c0503fbfc02ba0ea100b916fa31be290f76"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bea0388baf1807235902da02ca26db175273a24dc4a98559a94fa72a94661f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ed55337dc02a646fc10dd1c8b3378f7d72f76fb70f2e85aef5c6e015c31dfe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce2646b20ba665d6dcfd74370b0e904b9351af8b254e295089443d283ef69802"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a5d166db5117108c37868fe79fb41329d31cc7895cbc786ff091c220ce5611e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bf967d8b9942b5d9728dc258b1ec0fc2c22d97d8ae07f114e963d358cbae728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4737ee4fb2babcbaaaafc99330f28c12cf2050366679b006aaacfc864a296fbf"
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