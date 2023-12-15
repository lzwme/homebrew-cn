require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.98.0.tgz"
  sha256 "dc5412a14038737b465986bac56b52a28f6aaa39fdbf523caf0b07cf5ac41222"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f31e20efe32d3a568753ba20d1a77ab63fa797d2a4522f23365672f552cce28b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7e7f7716319e6a1a58c08872eb064a5166f8874015c0835a0e26d1bc01480ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1162b168f386faa8022b94e7e13e7b34159de492f72f9f8f9d2a256b35e318ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "45bf3fc99abc057db09027dab0fefd0e0d430d90b934322e647fc18d9fb79cc5"
    sha256 cellar: :any_skip_relocation, ventura:        "090946074744bc167a3097daef6bd90137d83262397964923006e3464d318621"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4a3070a11e502c0985f02c1d55d02f61052cb38beaacef5ee60f324af0be74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3baad7c3f346dedb8f7fcebaf90b656745cf2d22a6a6c75481ec9e2d15f6ece9"
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