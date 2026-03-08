class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "b9159304bfb813de6bf227f2ce7d435f893cd25b42c88390f602620f846d77fa"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1d9c1b3130a5851f8e1e6c2b8664db9bffeca8069347fbc3cf2fdaa1bf4c7ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1d9c1b3130a5851f8e1e6c2b8664db9bffeca8069347fbc3cf2fdaa1bf4c7ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1d9c1b3130a5851f8e1e6c2b8664db9bffeca8069347fbc3cf2fdaa1bf4c7ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "87e69c9d4b00ab386aa9b2502fd1933f57fb1aec9fabbf8cdea5626b2b7055fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "461482b309c8b40c67c07986e8c9e42c2046f47ca932df491ad60fcb02036512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "461482b309c8b40c67c07986e8c9e42c2046f47ca932df491ad60fcb02036512"
  end

  conflicts_with "xorg-server", "x-cli", because: "both provide an `x` binary"

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