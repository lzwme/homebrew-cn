class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.142.0.tgz"
  sha256 "e09d79e0e40a220973b82f82b3f015f52e9a819a7d78684f3ba2aa8497fc49a8"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aaf6eb383510fe64b2a0d58c0a56ea885266c6d8d9ae30f0510e10d7b1726fb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aaf6eb383510fe64b2a0d58c0a56ea885266c6d8d9ae30f0510e10d7b1726fb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aaf6eb383510fe64b2a0d58c0a56ea885266c6d8d9ae30f0510e10d7b1726fb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "76455230cd23cab5114144a565a2fb37ef211989e13c5a190483a705a2536596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "76455230cd23cab5114144a565a2fb37ef211989e13c5a190483a705a2536596"
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