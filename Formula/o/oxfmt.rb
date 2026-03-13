class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.40.0.tgz"
  sha256 "f2e2a79a0215dd5e59fd245c9f8055167c5f0647e030d1111e6b6a9aa2ffaeb8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7c96f6ddf7865f161f3a8e9fc999b6fa5c8ac65297db3ccf207cee382acd1c3"
    sha256 cellar: :any,                 arm64_sequoia: "48a88b45da3073b95c874438bd9e30c86919e32a99a647e472720abec4cbc18d"
    sha256 cellar: :any,                 arm64_sonoma:  "48a88b45da3073b95c874438bd9e30c86919e32a99a647e472720abec4cbc18d"
    sha256 cellar: :any,                 sonoma:        "097ea7a822b33ac33d4bbff97ae8f0d2aaba55f9017395b0ca3fa2bfc3e0d56a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec9a2e67fdae252bd9398c121533bc48f91be4900027d8b79f6dc7269b4dc533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b52207db1d4f3ac55d36ffdd0064830b24b1a9500c2c400ffffd10479a611a"
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