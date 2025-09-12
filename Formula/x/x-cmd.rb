class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "88aa9d67a58bafc707496aa595b52195da0ae6ae73920d40171cef58f2575fdd"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbabb79c99f1809345859801f13d6518551c03ddc8fcb79916fc136cb7da5dbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbabb79c99f1809345859801f13d6518551c03ddc8fcb79916fc136cb7da5dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbabb79c99f1809345859801f13d6518551c03ddc8fcb79916fc136cb7da5dbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbabb79c99f1809345859801f13d6518551c03ddc8fcb79916fc136cb7da5dbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f793e232e14589b14df0eebfbf649068359539c93d11dff5499efd0b26675fef"
    sha256 cellar: :any_skip_relocation, ventura:       "f793e232e14589b14df0eebfbf649068359539c93d11dff5499efd0b26675fef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f793e232e14589b14df0eebfbf649068359539c93d11dff5499efd0b26675fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f793e232e14589b14df0eebfbf649068359539c93d11dff5499efd0b26675fef"
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