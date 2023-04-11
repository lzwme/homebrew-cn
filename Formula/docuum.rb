class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://ghproxy.com/https://github.com/stepchowfun/docuum/archive/v0.22.0.tar.gz"
  sha256 "dea91f697115ce15aeafaca3cf824ae2730947a8dae84b89815b1254c11ceff3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "914f38327f9aacc8ee878fad35df4c3b1dc8e09ef4b4bac92c7b7855b7468497"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1fd37052db244f12636db316628b15fac6f2c39d0970a5d49298a46b8e2de5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c9ce4e7e1cf36ad586c5f72f204c455ee9c6fcd74837103974205c1bbeca78b"
    sha256 cellar: :any_skip_relocation, ventura:        "5557c24e8350d110a6f4244df90e465134ff9609fa3c98c68b551673287f1098"
    sha256 cellar: :any_skip_relocation, monterey:       "c4adb5d7b28460ae073c7fb210850d1fcd4e9e9b13acb86e3c2a7f970c349567"
    sha256 cellar: :any_skip_relocation, big_sur:        "628b7735616345853e9c9871964faf327705a9be3445975dfc3a50a705793b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27017e9feaf818c31b3f8928b9f5e747687311bb6532fa442d2f305d77e94bd1"
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
    environment_variables PATH: std_service_path_env
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