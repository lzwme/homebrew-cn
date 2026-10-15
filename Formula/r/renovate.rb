class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.155.0.tgz"
  sha256 "1aa0c3376efd6f21dd97eb20223978d1dda794a89e660b8a6cfc41aa410f7279"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98fed48893fd42f3db913289933f9b2c5a4ca679aa1337b0930f5af8f2ab93f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98fed48893fd42f3db913289933f9b2c5a4ca679aa1337b0930f5af8f2ab93f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98fed48893fd42f3db913289933f9b2c5a4ca679aa1337b0930f5af8f2ab93f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37b7806c7932a1c045fc2addbb8ffd2be8e84f7c33dfe61da725e88ad1a66e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "37b7806c7932a1c045fc2addbb8ffd2be8e84f7c33dfe61da725e88ad1a66e33"
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