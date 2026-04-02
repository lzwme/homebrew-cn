class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://ghfast.top/https://github.com/joernio/astgen/archive/refs/tags/v3.40.0.tar.gz"
  sha256 "e46f93cb7abd3a6ecdd150e096f52bbf5425aef14110ebb6dd7aa38fb7adcc22"
  license "Apache-2.0"
  head "https://github.com/joernio/astgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1cbf7a1230cb340d08121fc9dbb71567e6fb84885e34c2740fd615147185e71"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Install `devDependency` packages to compile the TypeScript files
    system "npm", "install", *std_npm_args(prefix: false), "-D"
    system "npm", "run", "build"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"main.js").write <<~JS
      console.log("Hello, world!");
    JS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match "\"fullName\":\"#{testpath}/main.js\"", (testpath/"out/main.js.json").read
    assert_match '"0:7":"Console"', (testpath/"out/main.js.typemap").read
  end
end