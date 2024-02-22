class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https:github.comquantumsheepsshs"
  url "https:github.comquantumsheepsshsarchiverefstags4.0.0.tar.gz"
  sha256 "905ee68f84210043e0589162ed36d41bf3583233d8a017dfa33dab7b90cf6006"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af49bea232ad195b77df2fcb9d1314e24ebe6437d91d569de55f51221849d43c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6d85acc2c0c1d790262bd715caf0eddf662c55b82868f3269592bd27d9e7061"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b195fc0bcd7a58788e7fee16605be1fff806f53f584999f448d9f5c9f0255c0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb1efb3f80107f1ce2c25314e35b8fa72a986966f556e3f2602f1ff9e4117b2e"
    sha256 cellar: :any_skip_relocation, ventura:        "c81af684ef2da4b81f667fac5b2873f809cdc2692b56b8fdacea010db36627a0"
    sha256 cellar: :any_skip_relocation, monterey:       "fbd53128fdfc27d7b6fea61506fad17ab96bb81e09983bf209e715a2945fea1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d425f6b6bfb66c6b11df3c32a7dfa38c97c9175bd14adfba76c6791a6164c92e"
  end

  depends_on "rust" => :build

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