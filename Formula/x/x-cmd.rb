class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.13.tar.gz"
  sha256 "b33cdbc509370861009215bafcef68ddc3d9c3090c5f9c407a7015541e6ea334"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e94309c58259ded1bab520b2421a07a65a7661341b93046dcf9eb59c566f02a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e94309c58259ded1bab520b2421a07a65a7661341b93046dcf9eb59c566f02a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e94309c58259ded1bab520b2421a07a65a7661341b93046dcf9eb59c566f02a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3cf3300ec8e01b63e13acef4938f7647469bde45844de6fd1791d459937d17c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d957c672b5ae0d59768d2cd5c24953c19f971294f5354dc78b7e5cac0a4a135a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d957c672b5ae0d59768d2cd5c24953c19f971294f5354dc78b7e5cac0a4a135a"
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