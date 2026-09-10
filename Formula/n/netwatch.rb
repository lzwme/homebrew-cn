class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.30.4.tar.gz"
  sha256 "77f7a80105a61b409a3f5c2f00c9f499e3b32781c9ef38252f169e42d87a9cec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58aa64082a9c9fba37c9be5ae341edcf13ef9704b650968cba7245511044886e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1151dc7c5da7e3f58f612df612b1193fc9861e6ef5a9e84987232e6489a4f50c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e5d7149b2011717edd7353b6e97c07b63b574a059529e5244f480cedc96827"
    sha256 cellar: :any,                 arm64_linux:   "f075366d80bfd28581ec091127090245a35f9b8276092524113fe3dccd9bae51"
    sha256 cellar: :any,                 x86_64_linux:  "7c9c64428afacac30139fa418028ea7bca0f2898ae03e157f7fea2e2bcf6794e"
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
    assert_match "topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end