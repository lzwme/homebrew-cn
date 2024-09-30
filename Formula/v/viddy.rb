class Viddy < Formula
  desc "Modern watch command"
  homepage "https:github.comsachaosviddy"
  url "https:github.comsachaosviddyarchiverefstagsv1.1.4.tar.gz"
  sha256 "fb76b1d0a25a2909a5e105f75534bda05c8d63ad82c1fb4f1bb5f828773b30f0"
  license "MIT"
  head "https:github.comsachaosviddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3d41cb395420ac9914e2906299f820ccc98c8276537abebeee244ff2b389ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e60e18992427437db783ee94a6e2c3b84532f8d36132169213edca074f52463"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7925098e01e86fe99b4d6da21769a57c2ee50795e24d89413df95bf989223416"
    sha256 cellar: :any_skip_relocation, sonoma:        "652cf146d1b3de0f2f48288f108f2d6b8c2b0d0a7190fb82230f11bf87ef6316"
    sha256 cellar: :any_skip_relocation, ventura:       "52963f5e52663a5f2dceff98e2a687dc3560d2f87c372970a99af608a01e821b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b3f0304287820b1c5bc9ddea9bca8d2481327ee91c8374cd057b3b06de57259"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}viddy --version")
  end
end