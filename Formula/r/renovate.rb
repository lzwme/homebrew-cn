class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.131.0.tgz"
  sha256 "2d115eda35675577c1f81744f5bac8321d28ab36160351dbc34a1f1a8dddc5d9"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d36e28a947646ee8655fc426f68df5f58c1a56dfb8970fab946f9fb884bbfd9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d36e28a947646ee8655fc426f68df5f58c1a56dfb8970fab946f9fb884bbfd9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d36e28a947646ee8655fc426f68df5f58c1a56dfb8970fab946f9fb884bbfd9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ed0752c27b430a1f0c57931378f92493bed2039f55342fbe5d85d1a89e4f8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2ed0752c27b430a1f0c57931378f92493bed2039f55342fbe5d85d1a89e4f8f5"
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