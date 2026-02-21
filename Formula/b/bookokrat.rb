class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "b81f463d4a24bdcf6aff24d31132c068d0c4acea3913a736f4352c0bf0cfc52d"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "836187576a7e929ee749c5b0512779a20dc0c34dace0487fb21d1589f497a3ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e27899190e2c2981d137637cabd775e39d875c834d99453bc6056a9b4ccc06f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13ee2d1e43bba95561f7d6e80a3038709d5b6e6e52586c7ea13aec2db2f8f22a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c57b4bfb914483835c58bd3c0e3362fe9224df56c81b8cbf27021763b07541d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33abaae88339a594708d8cc99295d856ed4aa21386778ea20f29860579fbdf8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd5abdf8d2438b9db3b6486440e3267c33ad2e1d3c60482ed2d40d04126cc0d9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["HOME"] = testpath

    pid = if OS.mac?
      spawn bin/"bookokrat"
    else
      require "pty"
      PTY.spawn(bin/"bookokrat").last
    end

    sleep 2
    config_prefix, log_prefix = if OS.mac?
      [testpath/"Library/Application Support/bookokrat", testpath/"Library/Caches/bookokrat"]
    else
      [testpath/".config/bookokrat", testpath/".local/state/bookokrat"]
    end
    system "ls", "-alR"
    assert_path_exists config_prefix/"config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (log_prefix/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end