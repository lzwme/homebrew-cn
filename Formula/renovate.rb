require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.27.0.tgz"
  sha256 "6210716dc616afe60d953d54c3c1a2fd3435b9959b11dbe37794f904bf417be3"
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
    sha256                               arm64_ventura:  "ac9aff1b84f5ff26e2821d035c5123ae62d4a871bd8615c1ae702240e547be63"
    sha256                               arm64_monterey: "3d187983c8f16a0e70db6e012a65edbae9f824c0fa0a0441184300700b8e5c02"
    sha256                               arm64_big_sur:  "e18ccfacb8554ba6cdbd016884846bb3dba3d92528ea6176e40953a2cc4729d2"
    sha256 cellar: :any_skip_relocation, ventura:        "ea803525af74ab489a2d181eb3f4843d6bec27bf7c5bfb01d0fd446cc2091387"
    sha256 cellar: :any_skip_relocation, monterey:       "29b6c648573acc32aba7189eec0f1fa5874348eac4cd5d0185a4ae746eed7acc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9094bbac347960576743a88b041ee1227670ab044727b62a0c750a2dd6e1b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deb1164fbed2d4ce4c78570b457133ddcf8f7018ed7acea5e2678776d9f71a89"
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