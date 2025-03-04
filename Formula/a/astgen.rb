class Astgen < Formula
  desc "Generate AST in json format for JSTS"
  homepage "https:github.comjoernioastgen"
  url "https:github.comjoernioastgenarchiverefstagsv3.23.0.tar.gz"
  sha256 "ccdfd678c33773be85fb8d2407198d5da732fa69cee6b41f8ec776c43f417918"
  license "Apache-2.0"
  head "https:github.comjoernioastgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b4113eeeb99720bdc313a012a7dbc875c01a0c735d5ceffe70bcc8eacdef262"
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