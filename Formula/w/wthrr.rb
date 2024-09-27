class Wthrr < Formula
  desc "Weather Companion for the Terminal"
  homepage "https:github.comttytmwthrr-the-weathercrab"
  url "https:github.comttytmwthrr-the-weathercrabarchiverefstagsv1.2.0.tar.gz"
  sha256 "6dbad5cf37fc364ec383f3c04cb4c676b0be8b760c06c0b689d1a04fc082c66c"
  license "MIT"
  head "https:github.comttytmwthrr-the-weathercrab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7123670512710361d2f70dc58f080a71c423e560c82c9a17b597a661595f4cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ef173a19782510f7d3ad16b0c8af7f2eee4ab450b9f0e6ed536677523c2d0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bba93a070e6d97685a70aeb241d03abd390e5044ab30272abda2e26f01ba02c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "153f1ac8df16ffdaed4b9b8ac340c99abf3980fb7a762649b00c53f1993df221"
    sha256 cellar: :any_skip_relocation, ventura:       "a22a40a694871ae04aefb5df671b0bfd5c9594de31bf8c058077a6c7de677d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef3d52887274f149bda3757fd5044900312081789394a721aaae022073088e9"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wthrr --version")
    system bin"wthrr", "-h"

    require "pty"

    PTY.spawn(bin"wthrr", "-l", "en_US", "Kyoto") do |r, _w, pid|
      output = r.gets
      assert_match "Hey friend. I'm glad you are asking.", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end