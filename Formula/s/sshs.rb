class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https:github.comquantumsheepsshs"
  url "https:github.comquantumsheepsshsarchiverefstags4.2.1.tar.gz"
  sha256 "fe1138e0a48fdd07007da5d9713e5539736c94fdcc452203d52a7786bdcc8bd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dcae47f811b4ca24d02491469d2834b3666978b248f707693093e9915d748d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ff852be1a7d76e65c6ead3a32d6e22aefb36b24f037e7822186ae1f2e14b3b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ee6410ed20189df320b2b43fda6612027a4400b0ff3cf66dd7162ba9ad40a64"
    sha256 cellar: :any_skip_relocation, sonoma:         "c16b3f3186cdb03a11d514ce81fd4c8149ab738c2aad22362dcf8680b5712983"
    sha256 cellar: :any_skip_relocation, ventura:        "d6d3af701ae485188001a556fa1f2df04dbe25153a395e457cc1f7a4c2b411a4"
    sha256 cellar: :any_skip_relocation, monterey:       "66466389f71b0787a01325abe93c6ac7e65a2bb6bfaf855a2472477d2853db4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077ac2b7a88e5d2e824d203ba7de3ce2741fb2d805598e64622ddded18cda090"
  end

  depends_on "rust" => :build

  # upstream patch PR, https:github.comquantumsheepsshspull79
  patch do
    url "https:github.comquantumsheepsshscommita72101f8f535c0e4c22e195adcf452fe12bfc3fe.patch?full_index=1"
    sha256 "adb99b270c51d80f1945d26a6eef4513b878e0715444001245bba7af1097df08"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "sshs #{version}", shell_output(bin"sshs --version").strip

    (testpath".sshconfig").write <<~EOS
      Host "Test"
        HostName example.com
        User root
        Port 22
    EOS

    require "pty"
    require "ioconsole"

    ENV["TERM"] = "xterm"

    PTY.spawn(bin"sshs") do |r, w, _pid|
      r.winsize = [80, 40]
      sleep 1

      # Search for Test host
      w.write "Test"
      sleep 1

      # Quit
      w.write "\003"
      sleep 1

      begin
        r.read
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
  end
end