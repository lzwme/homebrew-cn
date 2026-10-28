class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.181.10.tgz"
  sha256 "0dcc6526aff15b663e6bd52839370493b0f05c09c005556d7f4361d2214930be"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c1aca45de737a9032c1e7ab96e7c49363045740395d900c8b192b24bc75adb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c1aca45de737a9032c1e7ab96e7c49363045740395d900c8b192b24bc75adb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c1aca45de737a9032c1e7ab96e7c49363045740395d900c8b192b24bc75adb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d60c830efc38c1f33e00e1eb81085949268938ce12bc079e1677d83ef00180f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d60c830efc38c1f33e00e1eb81085949268938ce12bc079e1677d83ef00180f2"
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