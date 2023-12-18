class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https:github.comabrauneggonedrive"
  url "https:github.comabrauneggonedrivearchiverefstagsv2.4.25.tar.gz"
  sha256 "e7d782ea7d1973b6b578899a84c4f90ba69302263b4be30d80a363ba8ba27eb3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c08ccbf9b2ca0b1bd266f884c0b9d20c4c6342afc6d08c0697f1f2c3e90e50a9"
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
      Enter the response uri: Invalid response uri entered
      Could not initialize the OneDrive API
    EOS
  end
end