class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.4.5.tar.gz"
  sha256 "e081811effef2f3bf5fb05db2026e78871fb109d5be6a9bfdbbac145ff102e71"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6fce0dd965194e721a27fb1fca101fd4f27ec83dfa758d4f487a97783304729"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33772978f20d18c17d52f7d038769ecc70431c65296a828cecaaa5f828071241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "901d2c4cc36bfe74950c9ca92cdcdd6a446f2acb9548e7b1f6892371835cb5ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfbe3f376bf2063e908a954d4ae5796eeded1f82798dad0701ed13ba120a7eb4"
    sha256 cellar: :any_skip_relocation, ventura:        "69c6dfd3f9cab538cdc984db4156e56af3e88bb9278484f29b60495f97f8ec09"
    sha256 cellar: :any_skip_relocation, monterey:       "77bf3d94db618e6007354df2b4da313ab72458a3d45a1a38e05dfdce05d1d01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5196c2989e8051fc750504d8d068d350e833be6d1849d4d0b09568c35a5c5e39"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin"ox", "test.txt") do |r, w, pid|
      sleep 1
      w.write "Hello Homebrew!\n"
      w.write "\cS"
      sleep 1
      w.write "\cQ"
      r.read

      assert_match "Hello Homebrew!\n", (testpath"test.txt").read
    ensure
      Process.kill("TERM", pid)
    end
  end
end