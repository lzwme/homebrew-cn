class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.115.10.tgz"
  sha256 "cab670365bbe73a0665f5db1e41ea00df95483d3613b8295b3d43e558df838ff"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f67c77fbd719a5478840d898a838603a4c4d299cb00122b0444de5a9b437d1d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f67c77fbd719a5478840d898a838603a4c4d299cb00122b0444de5a9b437d1d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f67c77fbd719a5478840d898a838603a4c4d299cb00122b0444de5a9b437d1d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81cd1f7d60a286d8665707ba7bd5c85cb50c2a90d546ca2018fad2a28c4ded16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "81cd1f7d60a286d8665707ba7bd5c85cb50c2a90d546ca2018fad2a28c4ded16"
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