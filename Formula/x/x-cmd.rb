class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "01c0d151fd42a67ef08e399f448e64aad14e990bc1eb817d6f67724f0b9ecfca"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac9490ea0c55968292cfc70c1b5f39adfba5fb01a5ec43593677fb97df04185d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac9490ea0c55968292cfc70c1b5f39adfba5fb01a5ec43593677fb97df04185d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac9490ea0c55968292cfc70c1b5f39adfba5fb01a5ec43593677fb97df04185d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8155be16b8d676885030c674a17e42a97c89150d3504351219bd7975856edda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8155be16b8d676885030c674a17e42a97c89150d3504351219bd7975856edda"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end