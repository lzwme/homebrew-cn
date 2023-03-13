class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://ghproxy.com/https://github.com/epi052/feroxbuster/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "1b0c5d95c9916121be26810c4fca0068cd338d072aa41c9f853ff84d3255d433"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e034aa16947460b2a9c2a9525d961120ba0d08dbbdba72a44afd7d253d50ec7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5926050353445572b65f1fa9667cd0c1626bc433d4d2a7d75a0b5ee5f5c89519"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "221fcf4a03934a11e35c00ef21a2527cdb77582223a6eb9bec4cb3813b8f973d"
    sha256 cellar: :any_skip_relocation, ventura:        "7f66865c18a15acad93415468877418dc5667fc994f9c573b3892c008db9e321"
    sha256 cellar: :any_skip_relocation, monterey:       "6b4118e33e840055e4dfc16bf280c32b6ec40d36f251cc27fb9fbf4952cac329"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e59def73c1c602391fc032762de27b49001540955bf7d2ad1e00fda61242d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079afe06cad179514120557aba69c9186482a240da473f05255e3196b62da648"
  end

  depends_on "rust" => :build
  depends_on "miniserve" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wordlist").write <<~EOS
      a.txt
      b.txt
    EOS

    (testpath/"web").mkpath
    (testpath/"web/a.txt").write "a"
    (testpath/"web/b.txt").write "b"

    port = free_port
    pid = fork do
      exec "miniserve", testpath/"web", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 1

    begin
      exec bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end