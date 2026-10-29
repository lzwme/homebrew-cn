class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.188.0.tgz"
  sha256 "11825a25c5b0df44bc85184adadfc910f09ecfb5f8e8d67b1239444d7022edfd"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c3b4716892eecbc154c1a78c4032c2e2ed64524934c37edffeeae46afc44389"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c3b4716892eecbc154c1a78c4032c2e2ed64524934c37edffeeae46afc44389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c3b4716892eecbc154c1a78c4032c2e2ed64524934c37edffeeae46afc44389"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0527c2668fc5397f1f499b8fb9707ae6be728ef8cdc0434a3d72595d3d891b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0527c2668fc5397f1f499b8fb9707ae6be728ef8cdc0434a3d72595d3d891b6e"
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