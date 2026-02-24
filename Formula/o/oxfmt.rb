class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.35.0.tgz"
  sha256 "ab48e388e7b3cea3b68fe4d54f51a0bd96fb56bea3a222505e4f4b78f42c5643"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0511faaff4326b8318493fd0f447dff283f7fb64885e57a8c31fc27eb8802d5"
    sha256 cellar: :any,                 arm64_sequoia: "431693ce94a52390bc5cef65d259feb80e5d15009f634f4d79e50bf0ccd1fa6d"
    sha256 cellar: :any,                 arm64_sonoma:  "431693ce94a52390bc5cef65d259feb80e5d15009f634f4d79e50bf0ccd1fa6d"
    sha256 cellar: :any,                 sonoma:        "64defbfbb0558d21785e01fa0e3218681f7767b8200e93cf622494566ed73362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28afe7a071ae2841d5d9b25c1f3240e20183ec6d0e70c0f0d5e321727ebc95be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "568721e420f7dc195603c44a656d5d19a1d93aa22d30ec8ea326d153df821c4f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end