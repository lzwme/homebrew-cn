class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.9.13.tar.gz"
  sha256 "8ce9cc17f36249591939d27de811a1c2110b047c711171d93d982ead79323632"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe934d8d15a55c65c3ffd01fc29fa0d43aa48fd854701d1877b97d8deb4e012c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe934d8d15a55c65c3ffd01fc29fa0d43aa48fd854701d1877b97d8deb4e012c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe934d8d15a55c65c3ffd01fc29fa0d43aa48fd854701d1877b97d8deb4e012c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7007f7ecc4f3f6bfc4703e060d755b29fa2ed5686d319857f367d67603e82e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b731fb79b6bcef2ea045e7e4e200e3578b3e2d214b784e7ee1fa42048b996a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b731fb79b6bcef2ea045e7e4e200e3578b3e2d214b784e7ee1fa42048b996a9c"
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