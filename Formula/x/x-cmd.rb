class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "4d31e35899143f2b100826ff2dc12893a41345ccc96578852ad52ac9b5b4e01a"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89d963d458a56cab62ec9cf04b7e1703282df016376e19df740f3db4fb500128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89d963d458a56cab62ec9cf04b7e1703282df016376e19df740f3db4fb500128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89d963d458a56cab62ec9cf04b7e1703282df016376e19df740f3db4fb500128"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7794c13115c2d1ffecfc0502de9d0dd8675839f72d10b2ec6fa38158efa0e50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43e8353f003173d8abc1bbaa78ad0cea44521d5e87cf8b1961e377258750624e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e8353f003173d8abc1bbaa78ad0cea44521d5e87cf8b1961e377258750624e"
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