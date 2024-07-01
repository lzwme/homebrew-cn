class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https:github.comquantumsheepsshs"
  url "https:github.comquantumsheepsshsarchiverefstags4.4.1.tar.gz"
  sha256 "8b079ffc047b7cb2eab9f4a5eb4f954c9944e5de0b50de4d643595038782e9bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fcd2318b3c2ff8d7c9851c59694ec37506437bb0247591d9f55b3028aa1bb41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c3edc6d862024cef27f77f53ea1ae1d1a82722e935192aa56b6ef3cd7cc686d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba30e27e54ff65cd7212464f09ec62fa288373e8258b507c262becb72ba6cf60"
    sha256 cellar: :any_skip_relocation, sonoma:         "e97f353e1cda6b791d2f8769594348ccc347ad903916c4e36574dddb3875fe8c"
    sha256 cellar: :any_skip_relocation, ventura:        "4636c60465748f70139e8033c83fe029eadf182d1d24f116fe0e90f2b3fa31e2"
    sha256 cellar: :any_skip_relocation, monterey:       "81eb4f62c65ae451a7b949119b9e6df9c49806b8eeab6d6716eb8022e1c2970f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bf854deb5d4d57b98776ecde14932f5331c573c0fd4b21abdf86b3b50ff8828"
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