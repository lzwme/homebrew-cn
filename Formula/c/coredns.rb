class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://ghfast.top/https://github.com/coredns/coredns/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "9ad9d2a4ed708f235a6d0a3275cc0988973953228f539e50fdabe493c64a112f"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff5a33c71f41d3e94a63110636a07e05204122d36116d98834a8a4f4a7cb62fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1cbd4d39f72d471266a500a4502a0161f8335c0b6be4d4a172f48c8c9e954ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1619c8e193a8bded1ad0097984b4245df9e9c2538d90b2dc189096018b02fe80"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d52a0fb097a9807d9ad179080613f8e77b4a8f65e45438c10ab4600953399ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91c27dac2930721dde165414720c65e947e4c8ba70f1ffe7d02aafe86e838e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2f072a4aa05e3f2dedb66c32cbe176f6226c9f018d0011b0ce7effbc3bea34c"
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
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end