class BrewGem < Formula
  desc "Install RubyGems as Homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://ghfast.top/https://github.com/sportngin/brew-gem/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "97edaea64f439582f359e1f01feb4e824ba0a9fabe8be4970b1607bc767b3694"
  license "MIT"
  head "https://github.com/sportngin/brew-gem.git", branch: "master"

  # Until versions exceed 2.2, the leading `v` in this regex isn't optional, as
  # we need to avoid an older `2.2` tag (a typo) while continuing to match
  # newer tags like `v1.1.1` and allowing for a future `v2.2.0` version.
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf10941a2ef965ff3165f835fb00bbb52d1aeb446852bf7d32f365ac17dda1a7"
  end

  uses_from_macos "ruby"

  def install
    lib.install Dir["lib/*"]
    bin.install "bin/brew-gem"
  end

  test do
    system bin/"brew-gem", "help"
  end
end