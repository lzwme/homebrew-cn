require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.127.0.tgz"
  sha256 "2bfd5d5c267b3317f01b011f7e1c44ade2b523d6367b5addff633ccc65052c1c"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b9a444f81c7122d703cbd31452a68a3a1b96d13a4ef525ea1a827c887cc5588"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f35dfdd05c45299918eb0b7cfbf97d8e90d568b78c3908287ed68681ae4b28b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cb2eba96d33e7848d8f1a73210313fb7f9357fbbfe679a93f92154f2afe1a93"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf77e23ce6b8d457f581a0d19cc617c8b3047544d284bc0749d06c07e5788fef"
    sha256 cellar: :any_skip_relocation, ventura:        "33a1dee9892a6310bc3e25b9c16c1c339ac8350c543b15298389619913a38ddc"
    sha256 cellar: :any_skip_relocation, monterey:       "76c3ff53d3f00582f66faf15c6342f3e6630a91c74f2fedfa1ec7bd008de92b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b36d98c3879f466079a075924460e420104b284d8a654ba86b0b71464d6a3c"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end