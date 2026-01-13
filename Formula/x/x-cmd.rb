class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "62e438a14d3ff082a157c5cc9fb83a0af0fcf6a129bf063dc893349f92351a8f"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a6d7e1cdab50c364693ac100049beb2938f4d3fd43c84d4adc1857509c7dc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a6d7e1cdab50c364693ac100049beb2938f4d3fd43c84d4adc1857509c7dc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1a6d7e1cdab50c364693ac100049beb2938f4d3fd43c84d4adc1857509c7dc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d0b6e1dd2967ca7e9a2dd83f234d0bbcf74a56bb3737b60681fabbbf31adad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4bc822fbd8812918c64d30bfca61ff68b977ef34829000d9b342d11a73a8e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4bc822fbd8812918c64d30bfca61ff68b977ef34829000d9b342d11a73a8e51"
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