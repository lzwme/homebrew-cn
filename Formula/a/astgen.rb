class Astgen < Formula
  desc "Generate AST in json format for JSTS"
  homepage "https:github.comjoernioastgen"
  url "https:github.comjoernioastgenarchiverefstagsv3.21.0.tar.gz"
  sha256 "3a2947943e428ddb3881245f1e7fd2e0c38dfc472a70d75264698b6fdea28df2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ee20160dcccd4f33123a7c5eab06c9fd9f792aa572303ffb765be885f33d5f2"
  end

  depends_on "node"

  uses_from_macos "zlib"

  def install
    # Install `devDependency` packages to compile the TypeScript files
    system "npm", "install", *std_npm_args(prefix: false), "-D"
    system "npm", "run", "build"

    # NOTE: We have to manually install `typescript` along with the package
    # dependencies because it's `require`d in `TscUtils.js` but is only
    # specified as a `devDependency`.
    system "npm", "install", *std_npm_args, "typescript"
    bin.install_symlink Dir["#{libexec}binastgen"]
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