class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.36.0.tgz"
  sha256 "25d8a9e7ea6ce5fbff8114a3d44576e39ef3ffa01de053e147c29ff1dbabf473"
  license "AGPL-3.0-only"

  # livecheck needs to surface multiple versions for version throttling but
  # there are thousands of renovate releases on npm. The package page showing
  # versions is several MB in size (and the registry response is 10x that),
  # so curl can time out before the response finishes. This checks releases on
  # GitHub as a workaround, as it provides information on multiple versions
  # but has a much smaller size.
  livecheck do
    url :homepage
    strategy :github_releases
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d989ec62154d500d69cc5eb6ff85c81fe04559c0c8e32f9d01c9ad2c3f864d7"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Renovate filters child env vars, so Homebrew's git shim cannot run.
    ENV.remove "PATH", HOMEBREW_SHIMS_PATH/"shared"
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end