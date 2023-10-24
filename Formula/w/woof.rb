class Woof < Formula
  include Language::Python::Shebang

  desc "Ad-hoc single-file webserver"
  homepage "http://www.home.unix-ag.org/simon/woof.html"
  url "https://ghproxy.com/https://github.com/simon-budig/woof/archive/refs/tags/woof-20220202.tar.gz"
  sha256 "cf29214aca196a1778e2f5df1f5cc653da9bee8fc2b19f01439c750c41ae83c1"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "ec567cc35e9da2aad1a4b369960f1a6c9823dda502936968225a231a275bf623"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "woof"
    bin.install "woof"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/woof", "-s", "-p", port.to_s
    end

    sleep 2

    begin
      read = (bin/"woof").read
      assert_equal read, shell_output("curl localhost:#{port}/woof")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end