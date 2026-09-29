class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.117.0.tgz"
  sha256 "2f1deae15b8ff2e50a059fe8859f8f5010605cd1200105e1f131100446eee1da"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9a096aa959c35eb51128ae1529c02b3bc8dae951d781d54e12624d1cdfaf031"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9a096aa959c35eb51128ae1529c02b3bc8dae951d781d54e12624d1cdfaf031"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9a096aa959c35eb51128ae1529c02b3bc8dae951d781d54e12624d1cdfaf031"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2716b5d8f9c265b895501c6f917695fe735d11b3986769045ad77dff63e2fc28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2716b5d8f9c265b895501c6f917695fe735d11b3986769045ad77dff63e2fc28"
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