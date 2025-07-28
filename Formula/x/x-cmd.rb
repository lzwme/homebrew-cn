class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "69a12b98ed396b0c4d349a69c6e86e67782ec7765ee547294ca5951f79ed9b4e"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3513ddd9f98e245767e82db21fe8cc391effa3b665cd2a39238c086dbfaee4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3513ddd9f98e245767e82db21fe8cc391effa3b665cd2a39238c086dbfaee4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3513ddd9f98e245767e82db21fe8cc391effa3b665cd2a39238c086dbfaee4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeaa11ced385ba645233dbff326fe4601cc8ce4d6e06a7b4be36430564682628"
    sha256 cellar: :any_skip_relocation, ventura:       "eeaa11ced385ba645233dbff326fe4601cc8ce4d6e06a7b4be36430564682628"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b88ae42737326d1c1776a9db4df1140fa28271639b9040c917abf52517d17ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b88ae42737326d1c1776a9db4df1140fa28271639b9040c917abf52517d17ca"
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