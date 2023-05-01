class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://ghproxy.com/https://github.com/soywod/himalaya/archive/v0.7.3.tar.gz"
  sha256 "5bfadca9d6141834c3a97d53a43bdd317e59ee4f893bcc00e6fcbf9fc0f5b55a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41b7191b1cd36ee358aed11f570cfa842b98214fba02ae4d354eaf63efb26fb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b57900dc669ef2c6b4ca090ea44f1fa2c38cdb21b941e16b9c032834835d4c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6634f91efb185c79b7c050efa85ab9e777595c2ef9d973fc73606f753a4132c"
    sha256 cellar: :any_skip_relocation, ventura:        "71ffb9bef4aa418b6a86f00e7e20b70dcf826847533c9cec1e2a9b572a3f97f9"
    sha256 cellar: :any_skip_relocation, monterey:       "35a90c035e0a20f3ad6668fa8ccbb94b3199c7d959e42b7aa2a6c10783e098ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "deca93000325093d8c4c3e5e60cc7e8ab823e6fdf20d193c0cfe693967bf6067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18479b8e7d9451a0aca3d99cd7e4d7aa4deb4a80f861eff0b001979b956166b3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"himalaya", "completion")
  end

  test do
    # See https://github.com/soywod/himalaya#configuration
    (testpath/".config/himalaya/config.toml").write <<~EOS
      name = "Your full name"
      downloads-dir = "/abs/path/to/downloads"
      signature = """
      --
      Regards,
      """

      [gmail]
      default = true
      email = "your.email@gmail.com"

      backend = "imap"
      imap-host = "imap.gmail.com"
      imap-port = 993
      imap-login = "your.email@gmail.com"
      imap-passwd-cmd = "pass show gmail"

      sender = "smtp"
      smtp-host = "smtp.gmail.com"
      smtp-port = 465
      smtp-login = "your.email@gmail.com"
      smtp-passwd-cmd = "security find-internet-password -gs gmail -w"
    EOS

    assert_match "Error: cannot get imap password: password is empty", shell_output("#{bin}/himalaya 2>&1", 1)
  end
end