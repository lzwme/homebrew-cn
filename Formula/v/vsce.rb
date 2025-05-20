class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https:code.visualstudio.comapiworking-with-extensionspublishing-extension#vsce"
  url "https:registry.npmjs.org@vscodevsce-vsce-3.4.1.tgz"
  sha256 "ec05b141f3b67f9c5d37867a7d79b04b1964c120b070179d15eb4cd49f55bb1a"
  license "MIT"
  head "https:github.commicrosoftvscode-vsce.git", branch: "main"

  livecheck do
    url "https:registry.npmjs.org@vscodevscelatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "9aeda94de1fc069a48c666dc03ea65ef0dd8415d5c149ac19dff23d80a893426"
    sha256                               arm64_sonoma:  "79eb5600981ae8ac4289821095ad089b2b6ca1be3c78483336ed83176f45803d"
    sha256                               arm64_ventura: "2e32254c8fd22e998ebc6600bea149038e3c6f1382196e423eac99f97bdf164a"
    sha256                               sonoma:        "f97937187bb508ad75aa7c7783530fd06fac4325037ecf2271329a2d901fe51f"
    sha256                               ventura:       "7b7161ea2ef0650d17f487c2e21cca3abf8158dc670c336024c9fc3fb1ca6508"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1f6cedede58b75d279ca4739fece82c9aef71d95b2962cf81c4c12e87a5766b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d555e5705531bc80990475e0e1c0073e72abaa1ca5afe2b51747ec73a9a10f5"
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