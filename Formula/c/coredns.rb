class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://ghfast.top/https://github.com/coredns/coredns/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "8a9f8729476bdf265d5990dea86c314db778aec2f79d3d47e43607903f7d0b37"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ecd6090ae1b45159909b7d6d0817a01931473b127b17db653918326867edba4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4d2901fcf81416cdeb317d43466a2421d31f060483f3255ccb5f57c4fcbc41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc17f7db7819c050150e13ebdc2e629be41731163c3d63e0673ee1ab114a935b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a55ec56da06f0585adc1e8156a86c6447ece1989179b0ac3e2cdf5735b09d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef4efa4ce1a0a088a4733683789f31d61152219e996938866d7900b84bb76ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4b8ec42b7a725161942cdf1fdd9777a218c7dd728c5595767aaeb405f2701ab"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    spawn bin/"coredns", "-dns.port=#{port}"
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end