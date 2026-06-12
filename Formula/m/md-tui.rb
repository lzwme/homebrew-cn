class MdTui < Formula
  desc "Markdown renderer in the terminal written in rust"
  homepage "https://github.com/henriklovhaug/md-tui"
  url "https://ghfast.top/https://github.com/henriklovhaug/md-tui/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "24ebda2ed5bf630068f4a8a8fb07eb0c7f3ce0303a27cd311684fbcddc7d4499"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed75d27b8f08a7ea5ac41b421265a0e34c2dc1bb6c4a693671e778613819edd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89cdccbd3fa3614f5569ceaa25f10c4f4d757500c8139fb8de5a763ed00f905b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0d72ca0cfcf98974807ff97ec31ebf1ed0371b353efccf731e8c5c8669d1f97"
    sha256 cellar: :any_skip_relocation, sonoma:        "2667f859f7c2e80ab805cf5ed445afb7aedde351a1ce4dd0065c82d29b3fa5d9"
    sha256 cellar: :any,                 arm64_linux:   "289a74f12a2d621888beab188ab836ebc6a7a46853f112fcd348ab16c36c2222"
    sha256 cellar: :any,                 x86_64_linux:  "69781e2d57cb47e8401982194e58eafb272281f416836d61b78fde1580daeb92"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"test.md").write "# Hello World"
    PTY.spawn(bin/"mdt", testpath/"test.md") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match "Hello World", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end