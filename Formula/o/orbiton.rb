class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://ghfast.top/https://github.com/xyproto/orbiton/archive/refs/tags/v2.74.5.tar.gz"
  sha256 "dbd06b13734d53ddfa12bb3d92cc2ac967a4ddd59940eba5391ab8633e781046"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26b6184c603745eaaeb85bb7f5dae9ee1784950d6673661e30c08c73eb3ed0e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26b6184c603745eaaeb85bb7f5dae9ee1784950d6673661e30c08c73eb3ed0e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26b6184c603745eaaeb85bb7f5dae9ee1784950d6673661e30c08c73eb3ed0e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d0d57bb2e2bd3acf4fafeece04fa610e581901182b36c91a7f7573762dcd54f2"
    sha256 cellar: :any,                 x86_64_linux:      "ac09571ed46ca3bf594d3f856b101ee7fbf9decca5b740b4452076e3d263e841"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip"
  end

  deny_network_access!

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"hello.txt").write "hello\n"
    copy_command = "#{bin}/o --copy #{testpath}/hello.txt"
    paste_command = "#{bin}/o --paste #{testpath}/hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
      assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
    else
      # `--copy` and `--paste` need the pasteboard, which the test sandbox blocks
      assert_match "hello", shell_output("#{bin}/o --list #{testpath}/hello.txt")
    end
  end
end