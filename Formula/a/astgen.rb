class Astgen < Formula
  desc "Generate AST in json format for JSTS"
  homepage "https:github.comjoernioastgen"
  url "https:github.comjoernioastgenarchiverefstagsv3.28.0.tar.gz"
  sha256 "3036efa603e62feff14e5520bb24242ca8a275bf7e07f630fae45fcf21b5ea23"
  license "Apache-2.0"
  head "https:github.comjoernioastgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eca14b118708f772dd000d4f4662a196798164b35f57ddc846db367f34f5b84c"
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