class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://ghproxy.com/https://github.com/epi052/feroxbuster/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "8e6a3f25fbb74649754a7473bb84b1cf4f3ba14718040f1dcfcbc5358887291e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ce0012d75c2a1962f3004ed0b2a3b9473469a453466e8acf20ef262189d3c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62377af647edd1d59de3094c7a630b8ae160d63c5c8fccc981ce954682bb32b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4008bfeda42923d8c911d2b5b2f49bbc466037d053c663db0cab0f62b9edbb64"
    sha256 cellar: :any_skip_relocation, ventura:        "11579122259ec66ea82b5587a6391541f9c8898238e6e8afd962d151a9514cd4"
    sha256 cellar: :any_skip_relocation, monterey:       "5016cb589ad409f6bebe10311859d529f78f1d28fbad56a34d1e46572bbbfb41"
    sha256 cellar: :any_skip_relocation, big_sur:        "eda56bb0c526455f66f9138c3ccfa6e23468900eeacc10e3b9e9113de1984410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260ec04207cbcf3e1871e95860257dc94aff24efd1ee366ad733c036e16dd487"
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