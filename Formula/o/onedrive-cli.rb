class OnedriveCli < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://ghfast.top/https://github.com/abraunegg/onedrive/archive/refs/tags/v2.5.8.tar.gz"
  sha256 "dd10bf958326d452dec0848ea334c8da2d4d891790c81383a442bba62a9c4633"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "bd53e64fd22a3e55bdf60e5bcc60a169d8c8f4129fdefb4aa77a80b3d42e521d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b463100795b2e4e7f2cc863f8b38d8b20b34313d1095cc7cea6796db2d3f150"
  end

  depends_on "ldc" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "dbus"
  depends_on :linux
  depends_on "sqlite"
  depends_on "systemd"

  def install
    system "./configure", "--with-systemdsystemunitdir=no", *std_configure_args
    system "make", "install"
    bash_completion.install "contrib/completions/complete.bash" => "onedrive"
    zsh_completion.install "contrib/completions/complete.zsh" => "_onedrive"
    fish_completion.install "contrib/completions/complete.fish" => "onedrive.fish"
  end

  service do
    run [opt_bin/"onedrive", "--monitor"]
    keep_alive true
    error_log_path var/"log/onedrive.log"
    log_path var/"log/onedrive.log"
    working_dir Dir.home
  end

  test do
    assert_match <<~EOS, pipe_output("#{bin}/onedrive 2>&1", "")
      Using IPv4 and IPv6 (if configured) for all network operations
      Attempting to contact the Microsoft OneDrive Service
      Successfully reached the Microsoft OneDrive Service
    EOS
  end
end