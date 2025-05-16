class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https:code.visualstudio.comapiworking-with-extensionspublishing-extension#vsce"
  url "https:registry.npmjs.org@vscodevsce-vsce-3.4.0.tgz"
  sha256 "c32c2df34a752388f3fec0fc02ab15a3db2b11a57b58af15556dd1f1288c52b0"
  license "MIT"
  head "https:github.commicrosoftvscode-vsce.git", branch: "main"

  livecheck do
    url "https:registry.npmjs.org@vscodevscelatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "5b509cc5b1e9ded5b6f522a25364c7a29c831d1279cabc1e2187de42c0cffe87"
    sha256                               arm64_sonoma:  "203cd0b78833ee333823fa993ecf2cdff97f0ca59547d0393dcdc66b20a01033"
    sha256                               arm64_ventura: "0d488294cc71f75bd2b5e8e8ee50f67ec96de4869d0c24b924d2e0247ef29249"
    sha256                               sonoma:        "9c94d1048cdf9c4ca43fd898debe8de160643375d7c1031341e1d0974842e96e"
    sha256                               ventura:       "1a13b816877e2caf83211242af9e03e007e762eb647f3feb59f7679b43a5bc18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2381d5bec341f81b55f44b2d33e1135a080e50c43564fb68466f7af5e16fa61d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27e9631fe29147affdcacd0a03e2dd6f004685148b17402c01ecfe3d14f68231"
  end

  depends_on "node"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec"bin*"]
  end

  test do
    error = shell_output(bin"vsce verify-pat 2>&1", 1)
    assert_match "Extension manifest not found:", error
  end
end