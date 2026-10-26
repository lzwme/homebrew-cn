class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.181.0.tgz"
  sha256 "ff6f32c4f370718854d2d5a2bd0c854f6830acf3b01ffba805c28025b1bc6fc6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c6375e92c98103010a17e558e391080e73bd59e73c6810d352cd838b4d56855"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c6375e92c98103010a17e558e391080e73bd59e73c6810d352cd838b4d56855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c6375e92c98103010a17e558e391080e73bd59e73c6810d352cd838b4d56855"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66d26e73cd07f6b42909d859eb67c795cb4068c54c468a58ad4102b5fbb41a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "66d26e73cd07f6b42909d859eb67c795cb4068c54c468a58ad4102b5fbb41a79"
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