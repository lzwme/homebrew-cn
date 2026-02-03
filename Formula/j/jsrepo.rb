class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.2.1.tgz"
  sha256 "3de46f1313f15f1286576f7db2f07522879ff7cfa89da5c02aa78efbcab4ea8e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "926d76fbb8466d04727c4f7908c05907f78d02ebb5f61e5213a494a027106f76"
    sha256 cellar: :any,                 arm64_sequoia: "cb2e23bb425e516ff4172d3ab831290d5ea2ef873fc07ce73449fd4d4ce386c1"
    sha256 cellar: :any,                 arm64_sonoma:  "cb2e23bb425e516ff4172d3ab831290d5ea2ef873fc07ce73449fd4d4ce386c1"
    sha256 cellar: :any,                 sonoma:        "f5e342c5eac5642cbc6d544eaa899f7589a9fe2d6f5d520ebf83d1d1166c8804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233ed2dd2143e58e1c36226c50091c28bba03a70f4dc9280ec92c31ad7d86dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "058f293ccfbe0289853097eca6e0a999380e01ca2ee7803a8c2a74afa70a5d94"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end