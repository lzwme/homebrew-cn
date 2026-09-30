class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.121.0.tgz"
  sha256 "1623be99bb1b2adf6d1a93650281964efeb7ced66946e474fbff87e5b007d49e"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83fb36629f110760b204d1e6031d821790f7abde9a4458f1702d585702a9f4b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83fb36629f110760b204d1e6031d821790f7abde9a4458f1702d585702a9f4b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "83fb36629f110760b204d1e6031d821790f7abde9a4458f1702d585702a9f4b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "961dfb916b22e419ef6694764113e5984d8e55a0a8416a556b9e030c0bfee2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "961dfb916b22e419ef6694764113e5984d8e55a0a8416a556b9e030c0bfee2af"
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