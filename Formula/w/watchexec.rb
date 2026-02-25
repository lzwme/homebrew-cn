class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://ghfast.top/https://github.com/watchexec/watchexec/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "080b6ef6d1c5b030def96ac8c4e4d3fec85091b320088144d345331d3e51eeec"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b40c93b6aa0dee7796fd6ffe33a228fd64c4f34255a99bf097fad3cfdd53a71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5be8ab8c468dc1722a075bc5e69b80c6ab73a7da7eebd2dfa3f1b0bb5c798c71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90ca3b2b05d65f947d7c3a2ea1a485769dd0e675cf254fa753d5873a415237c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e454bdf4eb0609a7a8edfa937cabacb2e277d09a4e3d1dced094999cf449744"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd4220ab13ea6fece634dda010992af4a91e1800e8d802cd0c578cf27b96d240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc6b39f350693e855a1c077deaf8d0e00dc78122546feccd940cfe30c133f44"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end