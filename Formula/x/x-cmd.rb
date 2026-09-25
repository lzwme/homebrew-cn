class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.12.tar.gz"
  sha256 "f33a29e2232570e117bb96285fe3fcb7a39536f920fba07dfd06b345745d48d6"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7ee61eedef9b76b25ea600a2b2045e9318d5bfd9884d191a84153bb399e980f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7ee61eedef9b76b25ea600a2b2045e9318d5bfd9884d191a84153bb399e980f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7ee61eedef9b76b25ea600a2b2045e9318d5bfd9884d191a84153bb399e980f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "28ae9d449643298d73dddd444acc7e5983b931e379a2d3c874a02879e38e9cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "28ae9d449643298d73dddd444acc7e5983b931e379a2d3c874a02879e38e9cd4"
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