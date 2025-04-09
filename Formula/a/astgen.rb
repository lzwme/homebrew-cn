class Astgen < Formula
  desc "Generate AST in json format for JSTS"
  homepage "https:github.comjoernioastgen"
  url "https:github.comjoernioastgenarchiverefstagsv3.24.0.tar.gz"
  sha256 "4014f06eceb0dd0d98ac202c59b5dd27ea298e584cf91f5a56236be45f45d91c"
  license "Apache-2.0"
  head "https:github.comjoernioastgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "109cd664cedbcc3d86f502a7fd116f5cb473fc05f39b8d542627186eb938d8c3"
  end

  depends_on "node"

  uses_from_macos "zlib"

  def install
    # Install `devDependency` packages to compile the TypeScript files
    system "npm", "install", *std_npm_args(prefix: false), "-D"
    system "npm", "run", "build"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    (testpath"main.js").write <<~JS
      console.log("Hello, world!");
    JS

    assert_match "Converted AST", shell_output("#{bin}astgen -t js -i . -o #{testpath}out")
    assert_match "\"fullName\":\"#{testpath}main.js\"", (testpath"outmain.js.json").read
    assert_match '"0":"Console"', (testpath"outmain.js.typemap").read
  end
end