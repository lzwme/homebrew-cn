class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.156.0.tgz"
  sha256 "b773c4a46fa49b7ab49b1c2efd39a8a9972598fb74b1710c2335d684e4edff0c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f96fe9b375cf5b65eb149a0aa7d1686d447b0d18579ed8e8988b983c162837c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f96fe9b375cf5b65eb149a0aa7d1686d447b0d18579ed8e8988b983c162837c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f96fe9b375cf5b65eb149a0aa7d1686d447b0d18579ed8e8988b983c162837c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0d7430e4458b31b504a58de39f9d8fb7ab909cb70a61945903c7371b0c6656b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0d7430e4458b31b504a58de39f9d8fb7ab909cb70a61945903c7371b0c6656b4"
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