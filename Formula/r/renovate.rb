class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.154.0.tgz"
  sha256 "2e72aaa6473656b21a815c4e8c0b8ef9eeedb3232954da44305d34442873c0e6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bac6081d87ed24eef34c19036d61e799459714cc3e5f551fc705b208de1edbd8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bac6081d87ed24eef34c19036d61e799459714cc3e5f551fc705b208de1edbd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bac6081d87ed24eef34c19036d61e799459714cc3e5f551fc705b208de1edbd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ad1a3b1aaab8b35108bd690b55892b7d3bc5337d51d31f974df0241f0f4c90b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ad1a3b1aaab8b35108bd690b55892b7d3bc5337d51d31f974df0241f0f4c90b7"
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