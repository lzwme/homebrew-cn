class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "c363a044118c870d96a50999a989033a4b662cf0800fcfc8deb948bee99b0b2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72aa564dcc1724b8761c95c8505dc9943906244e4ab873bdb15b790d779e8eb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50329e33d14e85cdbe4e7ec20819dfa735a05872e57520e164b909f0f449b139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb620e43bb5c830617fb6656f21a376de09ab92e53b1b20e58c4ec5a7a3194f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded2dd654e644bf595a503931136b9f90f37072360e03733443383634d8c6936"
    sha256 cellar: :any,                 arm64_linux:   "239d6c15280360dc1ad5c93c0c9c8298cf031df0c334796da9d6861b15e7cbb7"
    sha256 cellar: :any,                 x86_64_linux:  "d42cb89ac48f8e3cf6fbd914add65f8ee053f9a3ca530dde59380efcf5751ba2"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.ansi") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/netwatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "Topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end