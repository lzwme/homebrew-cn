class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.146.0.tgz"
  sha256 "fb9ac39b835ceb1ecd126c7ce2b5fd67c923231f5e4c7cd68bd1192be4c5e6c7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0c4d4c7ee0a7edde42dd2d7d4d1a9dc00850a397a470b46b3c96a0ccc5fff00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0c4d4c7ee0a7edde42dd2d7d4d1a9dc00850a397a470b46b3c96a0ccc5fff00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0c4d4c7ee0a7edde42dd2d7d4d1a9dc00850a397a470b46b3c96a0ccc5fff00"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fae2bdd566f8a75076ffe27b5ccd7d91125b22ca0c96fdc734cb4aa6d11c57a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fae2bdd566f8a75076ffe27b5ccd7d91125b22ca0c96fdc734cb4aa6d11c57a1"
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