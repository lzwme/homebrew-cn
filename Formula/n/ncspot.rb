class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://ghfast.top/https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "08a0be7e099bc40cf087a4ed8665a425c345a0e83019257d7c4affb7a1bbb881"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8048054bacc353778d1ddfb3c7f5b3210af57bea57438571daa63fc4a2ef351c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5abdfb5d713fcc981beccf9dec792d63fc3484bf7a297b679327b2732d08b7ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca49267c6c936720184f9031de484bfd95b9073f9ff14fa95a7b65101a91ee60"
    sha256 cellar: :any,                 arm64_linux:       "2814ad1f81765af7f93be9c2311ee66c04a99466c01f2fbc6ebfed7d76708436"
    sha256 cellar: :any,                 x86_64_linux:      "67b103b675a783083c805166639657bf39c173f6d0bf5c79778f1be671b2ee9b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
    depends_on "pulseaudio"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    if OS.mac?
      ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path
      args = %w[--no-default-features]
      features = %w[rodio_backend cursive/pancurses-backend share_clipboard]
    end
    system "cargo", "install", *args, *std_cargo_args(features:)
  end

  test do
    backend = OS.mac? ? "rodio" : "pulseaudio"
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match backend, shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    if OS.mac?
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "To login you need to perform OAuth2 authorization", stdout.read
    end
  end
end