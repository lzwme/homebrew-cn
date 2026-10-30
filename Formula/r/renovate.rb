class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.192.0.tgz"
  sha256 "928b4479899cc64af41fb110581ba48e7444e3daba16905f3656cd2b7fe14885"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00a98e5022752c1cee3c6e9d064906af8e46228efc44b371ec71797a13b899fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00a98e5022752c1cee3c6e9d064906af8e46228efc44b371ec71797a13b899fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00a98e5022752c1cee3c6e9d064906af8e46228efc44b371ec71797a13b899fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ec95208afce3cf9d2f673703cfe2012dbcd7b67a5265ad3ad05c5ccc7df0d56"
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