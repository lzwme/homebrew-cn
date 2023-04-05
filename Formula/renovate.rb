require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.32.1.tgz"
  sha256 "df62204499514d83eb5c7ee8b36d02c95288ce84202b462c496853b596406dbd"
  license "AGPL-3.0-only"

  bottle do
    sha256                               arm64_ventura:  "439399351ad7bdcddf2c6993458aaa5e315092864a0da412aac734e0fe9a872e"
    sha256                               arm64_monterey: "7b707d8f489e6eaa9bdcc21b58bb96722e068d8ec9a07df662f740e66178e7e9"
    sha256                               arm64_big_sur:  "4e215986cfa3855cb6c92dad87182311b83ffcc8129c632c3f5e10d28dae9e92"
    sha256 cellar: :any_skip_relocation, ventura:        "90302593f74c284293bc70c0cd8f5f852c9932b5189b79432c9f87093177fb15"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3c81809482bb5b7078e4b77e86c5674f1850f4a21748ed6cb9294bd7d862df"
    sha256 cellar: :any_skip_relocation, big_sur:        "9641248ccda6e7a4d06786f18af37d0cdcd9ad09d782a1008445abe126091c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13617812fc9da1e8b67bc4311e0547b60a01eab6f78d8a35ae24b4c54d4b0714"
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