class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.72.0.tgz"
  sha256 "bd76b27cabc788330680419f16141e26f1731c95b4196957f017f457be1ac065"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "038e14d92b77eb4a5893b152e1e56ee1e9bcd75303b963e1a2f4e861223a06e2"
    sha256 cellar: :any,                 arm64_tahoe:       "038e14d92b77eb4a5893b152e1e56ee1e9bcd75303b963e1a2f4e861223a06e2"
    sha256 cellar: :any,                 arm64_sequoia:     "038e14d92b77eb4a5893b152e1e56ee1e9bcd75303b963e1a2f4e861223a06e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56b0bf42267f56f6ea31498e8ce260f819910423b5bed315e433cd5c27da1e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b8efa0b5c8365d748b7b5d7902e8d5023654da03b57c9c489fdbfb3ef64c9d48"
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