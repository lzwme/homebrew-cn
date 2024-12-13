class CratesTui < Formula
  desc "TUI for exploring crates.io using Ratatui"
  homepage "https:github.comratatuicrates-tui"
  url "https:github.comratatuicrates-tuiarchiverefstagsv0.1.23.tar.gz"
  sha256 "104167275985e2811fa9c64af177bd2616ec6cd1b5a02e931f2afe5c6c29a191"
  license "MIT"
  head "https:github.comratatuicrates-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4f5b9288ddc35bb6e2de20f0f5e6bb260c08d6b580a60fc03014c215ea38db6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ee49a9c6e383a46c1a10589aee85cb132c0673fe564df630ab2f29e841dad4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2106fdebcd5d3a09b50d7943527b7b2677a8f0df2567a82cd6fcb9f73b8e329"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bdd74f2e3bc06bf68d2def74e89405b4c01418bf1fbdb861728f102a5518db1"
    sha256 cellar: :any_skip_relocation, ventura:       "49366877add0406ba87dd5952ac875d4938496991e06fd399abd5fa1c4b77851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71bf937c05cd606ba6aa226768789fefaf23706daf0adf3c7bf7e160388bd8b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}crates-tui --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath"output.log"
      pid = spawn bin"crates-tui", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "New Crates", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end