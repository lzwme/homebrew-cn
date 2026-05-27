class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  # TODO: Switch to npm registry URL when https://github.com/renovatebot/renovate/discussions/42965 is fixed
  url "https://ghfast.top/https://github.com/renovatebot/renovate/archive/refs/tags/43.196.0.tar.gz"
  sha256 "6634baff3e034456217ca5d8ac3c2b44d4af552de0bd6fb37ff86758b960dfc8"
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
    sha256 cellar: :any_skip_relocation, all: "b73c6f93b82cce0b3d0e69959e836652af30d5aa1969da8f28fff657f58a594e"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

  def install
    # Pin Ecosystem union member order to make :all bottle
    inreplace "lib/modules/platform/github/schema.ts",
              "export type Ecosystem = z.infer<typeof Ecosystem>;",
              "export type Ecosystem = (typeof Ecosystem.options)[number];"

    # TODO: switch back to `system "npm", "install", *std_npm_args` when using npm registry URL
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Renovate filters child env vars, so Homebrew's git shim cannot run.
    ENV.remove "PATH", HOMEBREW_SHIMS_PATH/"shared"
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end