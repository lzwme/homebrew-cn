class Redir < Formula
  desc "TCP port redirector for UNIX"
  homepage "https:github.comtroglobitredir"
  url "https:github.comtroglobitredirreleasesdownloadv3.3redir-3.3.tar.xz"
  sha256 "7ce53ac52a24c1b3279b994bfffbd429c44df2db10a4b1a0f54e108604fdae6e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e85d33d0d3a7fb6b68dbb5d94ad15d7aa150931c9d0761b1dfa9e2e1ab39bf24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c61f424df5b1d03951e0d7bce56a1df8e743fc23adfb6701e327ba9f5cf5b33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "958f14440ec0301e5e9cb0ae82f3f5080be3fd7336cbb9ca17211ecf84c88bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed393b34639f9ff4309c3b1ebb718578ad79fded885c244a691eb943c6a4e27f"
    sha256 cellar: :any_skip_relocation, ventura:       "9b6198a40516760f5aab31627aa111237ee5cac90cfb72243cfd91d6bbfb9bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d0afabc5b8a627139420184283cd83e9c277f5aabcf8f3c3192f0508116ec8"
  end

  uses_from_macos "netcat" => :test

  def install
    system ".configure", "--disable-silent-rules", "--enable-compat", *std_configure_args
    system "make", "install"
  end

  test do
    redir_pid = fork do
      exec bin"redir", "--cport=12345", "--lport=54321"
    end
    Process.detach(redir_pid)

    nc_pid = fork do
      exec "nc -l 12345"
    end

    # Give time to processes start
    sleep(1)

    begin
      # Check if the process is running
      system "kill", "-0", redir_pid

      # Check if the port redirect works
      system "nc", "-z", "localhost", "54321"
    ensure
      Process.kill("TERM", redir_pid)
      Process.kill("TERM", nc_pid)
      Process.wait(nc_pid)
    end
  end
end