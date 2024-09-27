class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https:github.comabrauneggonedrive"
  url "https:github.comabrauneggonedrivearchiverefstagsv2.5.1.tar.gz"
  sha256 "99c1ad66fe9f595b84e9de397767f8337066f911a0ad90371855d7fa906d3d31"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9118476e4d5c2459271abf201611e917736a39afbaa6207a9a58ad320648684c"
  end

  depends_on "ldc" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on :linux
  depends_on "sqlite"
  depends_on "systemd"

  def install
    system ".configure", *std_configure_args, "--with-systemdsystemunitdir=no"
    system "make", "install"
    bash_completion.install "contribcompletionscomplete.bash" => "onedrive"
    zsh_completion.install "contribcompletionscomplete.zsh" => "_onedrive"
    fish_completion.install "contribcompletionscomplete.fish" => "onedrive.fish"
  end

  service do
    run [opt_bin"onedrive", "--monitor"]
    keep_alive true
    error_log_path var"logonedrive.log"
    log_path var"logonedrive.log"
    working_dir Dir.home
  end

  test do
    assert_match <<~EOS, pipe_output("#{bin}onedrive 2>&1", "")
      Using IPv4 and IPv6 (if configured) for all network operations
      Attempting to contact Microsoft OneDrive Login Service
      Successfully reached Microsoft OneDrive Login Service
    EOS
  end
end