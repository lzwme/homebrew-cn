class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.175.0.tgz"
  sha256 "69615ca2b12b946edc025293e02e0b2225ce574bc49bb686fb33e1da5d2c7310"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6386bff7c173f42cd5cd728c62476af2b366729eab2f2daa30e95567302d331e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6386bff7c173f42cd5cd728c62476af2b366729eab2f2daa30e95567302d331e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6386bff7c173f42cd5cd728c62476af2b366729eab2f2daa30e95567302d331e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d217699d3210b56489eec97a60cb9486f5803b9d7ae51be1f5af304ba9ad0b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d217699d3210b56489eec97a60cb9486f5803b9d7ae51be1f5af304ba9ad0b17"
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