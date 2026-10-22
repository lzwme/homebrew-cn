class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.170.0.tgz"
  sha256 "6bd30cef91d5444f7eea9805aec2639ee6a5575dcb89413d31c4fd7aab09a35c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9174d13cf8e59e7e7380c0169dfc0041f654496a277541426fb54d9247fd3a50"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9174d13cf8e59e7e7380c0169dfc0041f654496a277541426fb54d9247fd3a50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9174d13cf8e59e7e7380c0169dfc0041f654496a277541426fb54d9247fd3a50"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "349a130374e1928d48b96db0d74aaa88142bce7f9b526b094858f1852b0fba6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "349a130374e1928d48b96db0d74aaa88142bce7f9b526b094858f1852b0fba6b"
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