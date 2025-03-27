class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https:code.visualstudio.comapiworking-with-extensionspublishing-extension#vsce"
  url "https:registry.npmjs.org@vscodevsce-vsce-3.3.1.tgz"
  sha256 "36f6acf5bdf9df5b1041ef4ec5ce4f866a528e06eabd6f3938426d2ee2150558"
  license "MIT"
  head "https:github.commicrosoftvscode-vsce.git", branch: "main"

  livecheck do
    url "https:registry.npmjs.org@vscodevscelatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "f1b12a6b4a889d022edc9a468b21991359530c6a850ab69b7899f30b9f3a6ff2"
    sha256                               arm64_sonoma:  "f024c3ed9d559d1490b94b85ed44c881a58973448503d35798204ccf7e53e19e"
    sha256                               arm64_ventura: "db6f4a73a0991e342c9e351694b3748a5fd7f78b8acd2de3a29114d148b486af"
    sha256                               sonoma:        "5e95b460386f0073a8c5dd6d1cb4aae9d8cd3fe03857196f224f02c07b712faa"
    sha256                               ventura:       "6fc8d2190891fa9568881082096bcd545963a0fd12f81680747f3e040f356260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e82946d028d32ad1005c404b53536284fbe3937bd8805a8fd03f17e0d5cb863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8188937f7a25d7ae5a7f30243092782446b9136e1735e48990ee8f191fa0001c"
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