class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://ghproxy.com/https://github.com/stepchowfun/docuum/archive/v0.22.1.tar.gz"
  sha256 "ab0759c98732c4081e996142fceef518c1543c659c86ef21fb4561b543d2e0d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47f9f67a6b2d3adf8c8a7122a1ca591a51a0993588263f8a612b9a8c50c90b44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7143e3b6ccd3b71558078963bfb02f8285f5270824267f4e01c9d3645f4c3d61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a505012f5505e08d5547956dfd65608d07b49a3ec686ce0cc6771050d28f46a9"
    sha256 cellar: :any_skip_relocation, ventura:        "71aae24f4a39bfd59ea08b5cf66346fa900369ee5573423917d9e8c06bbe1bfe"
    sha256 cellar: :any_skip_relocation, monterey:       "966c2bf890e03198a914610b305f82efddb06038dd4b8b61d8ebb9ab55eb8120"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eb57b77224c548aafbe4e3c7b1c959d210a8010c094d3654d8faf2ec4493df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3a41a802cc361945fb411c5d0812d25875896429c9aa02d1c28e4a5ef5fd34"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  # https://github.com/stepchowfun/docuum#configuring-your-operating-system-to-run-the-binary-as-a-daemon
  service do
    run opt_bin/"docuum"
    keep_alive true
    log_path var/"log/docuum.log"
    error_log_path var/"log/docuum.log"
    environment_variables PATH: "#{std_service_path_env}:/usr/local/bin"
  end

  test do
    started_successfully = false

    Open3.popen3({ "NO_COLOR" => "true" }, "#{bin}/docuum") do |_, _, stderr, wait_thread|
      stderr.each_line do |line|
        if line.include?("Performing an initial vacuum on startup…")
          Process.kill("TERM", wait_thread.pid)
          started_successfully = true
        end
      end
    end

    assert(started_successfully, "Docuum did not start successfully.")
  end
end