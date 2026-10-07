class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.133.0.tgz"
  sha256 "757daa78b3674c7e258addfea052bd9c4a7d51785d7179f3dc48d06468c30ab3"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f40f0cf214919f93a6d93b382fce7e0fd8b19846b9e7ee0a73b38c85e7990df2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f40f0cf214919f93a6d93b382fce7e0fd8b19846b9e7ee0a73b38c85e7990df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f40f0cf214919f93a6d93b382fce7e0fd8b19846b9e7ee0a73b38c85e7990df2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb576df30e302e00cb201987e8671466cf7139276f4c3c4379bd5529ca535fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cb576df30e302e00cb201987e8671466cf7139276f4c3c4379bd5529ca535fa1"
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