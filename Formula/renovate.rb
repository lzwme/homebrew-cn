require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.42.0.tgz"
  sha256 "7bd2548eaa9c652e49f0bb4e8e5325529df270e4f14c546658767448edbcf640"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8907194f3a595c91722765be4c57b3af61f786fe0cfa770bd6ecb5f42056eaf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "984672d5e0302eb0caf0043d60e135708a5d193dc3d645f120fbec793229e210"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc11b835828f1a235d40ccc051d01d80f0ef686cce9370b8b0f0ba91015c5b84"
    sha256 cellar: :any_skip_relocation, ventura:        "07a9c9c5fd467814ddbb54de9e50383051707d62cb7852df31073e217d0ec00d"
    sha256 cellar: :any_skip_relocation, monterey:       "7e74f40df4aecaf3b792ce8d9b24eb8e7192f1e714a39f87f9bd00c737828fe8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2aedf5f41f06c6b5b0c0190088330c8e78550c4f3e815f0e207f45360fd6f887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56ee946f45230660c6df80b83821100368f4f57df10f8ef54b41bb9a34144450"
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