class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https:github.comabrauneggonedrive"
  url "https:github.comabrauneggonedrivearchiverefstagsv2.5.0.tar.gz"
  sha256 "6ddf92bf564e71871d1d49e4120f0848f79bc3e55155a73c2b882752fa13a431"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5ef60eba305591ad6d90aab590004ef1ae734a71916cce7ebff83e1ae42ab299"
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