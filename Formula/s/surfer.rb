class Surfer < Formula
  desc "Waveform viewer, supporting VCD, FST, or GHW format"
  homepage "https://surfer-project.org/"
  url "https://gitlab.com/surfer-project/surfer.git",
      tag:      "v0.2.0",
      revision: "2d8dfae1e11aa9b843a3ee94ea99194417b36c59"
  license "EUPL-1.2"
  head "https://gitlab.com/surfer-project/surfer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd7b0c51ac91e29fde0266b4c1fdcef00910e31e7a06ef1eb4db182b429f9bbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "113cb8ba1da90363e7ba910c2e22f2a8d7f53c745bf055524d8c238e47a79c01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c1ae8711ae1b6913530447e707fbb2cdecf0f21c47535a0bd78e282b326df09"
    sha256 cellar: :any_skip_relocation, sonoma:        "69598f9d725b00ad2cf5af8e1dc7884fb50055af294cc69c2f2d4d63b0f2538d"
    sha256 cellar: :any_skip_relocation, ventura:       "8add1ebee71981af65a417c76fe0d304cdf05cc12d5dcc88004bd7cda3fc526f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb3855f6c6fb4e457389ec74da4de999382698a98b0f806304e988ae4ecbb234"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    (testpath/"test.vcd").write <<~EOS
      $timescale 1ns $end
      $scope module logic $end
      $var wire 3 # x $end
      $var wire 1 $ y $end
      $upscope $end
      $enddefinitions $end
      $dumpvars
      b000 #
      1$
      $end
      #0
      b001 #
      0$
      #250
      b110 #
      1$
      #500
    EOS

    token = "tokentoken"
    pid = fork { exec bin/"surfer", "server", "--file", "test.vcd", "--port", port.to_s, "--token", token }

    sleep 2

    output = shell_output("curl -S http://localhost:#{port}/#{token}")
    expected = "Surfer Remote Server"
    assert_includes output, expected
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end