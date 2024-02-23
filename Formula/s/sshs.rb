class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https:github.comquantumsheepsshs"
  url "https:github.comquantumsheepsshsarchiverefstags4.1.0.tar.gz"
  sha256 "b6b4ced5eca70e2b00b2269d2c53c1a512a5a74d24b9882c581d482b4dd6bf60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c36b525bc51e1e9b586506747ede46180884a5460df9406a9efe91e5cb29a739"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4afc79ee65b303615bc271128ab85bdf60c85eaada209a4522335aa727a32e33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "476716162d0138b4bdb2031836fa01495414de413d926cbfadf8bade293e6164"
    sha256 cellar: :any_skip_relocation, sonoma:         "d38b87a1edf8fbae570fc5e8b54189dbf18a0b583bbc312378af1034ccde9c6d"
    sha256 cellar: :any_skip_relocation, ventura:        "90f3d5cde7e6e846b025cba52a05362677cee4437456da8dc07c952022c7b5b0"
    sha256 cellar: :any_skip_relocation, monterey:       "9de239dee2e353d37e82521df79a452187de45cb2a64be19bb9735dcbc7fc618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d060a1126763c9b09d02d71e13b30732f38d06283a898ee0ff599f4a8da276"
  end

  depends_on "rust" => :build

  # upstream patch PR, https:github.comquantumsheepsshspull69
  patch do
    url "https:github.comquantumsheepsshscommitb831d0889a14c9f105456a2b4e5ee7d673f926d7.patch?full_index=1"
    sha256 "b8de54bcaf2c42aed878dc0d22a5b48cf0a509c2cd8c37913a36077ac48b3e4f"
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