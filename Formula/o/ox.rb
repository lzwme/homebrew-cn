class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.4.0.tar.gz"
  sha256 "504089d50ad549b013ca9108aaeb800928b35e4f36766ded4245c4026504073d"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee6ae091c741dac114e71949efcbaa1379580168b0b3f88a26d5ccd6b98eec54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "313f11c368eea5d37940051e2f54e55cb20ae31ed2da0ba3c94f9ba07216f488"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53d1e07e11924fd4d98d00aaa2ff2a17385b7900c04a7b965fee32c3f638dcdf"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b4c5a1d76028bcfc43081251e4ea529fc20603d2551e7ec9998f40425ee8828"
    sha256 cellar: :any_skip_relocation, ventura:        "97755ed2064519dd7fdba8bf6b6dd561976ecb40348a414119d2183efa1b4083"
    sha256 cellar: :any_skip_relocation, monterey:       "91548699028b90b62713d705702bd50c787cd5c8f58cc4f8b691f78b85b0b0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ae7d48392b27a54bf08fc8129479a21befd78d17623ec6b5293bba20a13aafc"
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