require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.35.0.tgz"
  sha256 "808231f104a4b110584236ece40bd19c1bb5b4a1b3325be98c254162b528af2c"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256                               arm64_sonoma:   "46a6b9c9aca2504c607255f349c2f74b15f408b1157ac355c898bb3a2aff0604"
    sha256                               arm64_ventura:  "978938d52278e8eab08cf034e6c40e1a1e20ac91d959c8d3687508c7bce0e2b6"
    sha256                               arm64_monterey: "a4e2e1d6f9bbb6ffd8a3f3c8bbde1b78a6d7b27d60c33df3d2eac00dc278ba51"
    sha256                               sonoma:         "b03a3e94d4a680e934239cbe02600a9317fed51b22561fffc79c253d931b4c34"
    sha256                               ventura:        "92dd6d49392d6f7b6ccc259861bd38295a423805c981d493cad806ba660ce36b"
    sha256                               monterey:       "9d03fff9f7783e3a18b7f7023c2e7fb8fc5097350f4f7544f74f24a82ce3b7aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6246e5448085b4cbce7df5b7b4da93c9784df6bfb3893a13e7766487fa791a9b"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end