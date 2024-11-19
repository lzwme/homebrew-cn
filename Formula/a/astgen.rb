class Astgen < Formula
  desc "Generate AST in json format for JSTS"
  homepage "https:github.comjoernioastgen"
  url "https:github.comjoernioastgenarchiverefstagsv3.17.0.tar.gz"
  sha256 "b989ca182c838e4e0aca56d0ddf55167884f7de7425e8557d1533a4c2f15de11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a3ff787bb98219536e744663035f15f53b7ee2db59ffee934b0a422fc73476a"
  end

  depends_on "node"

  uses_from_macos "zlib"

  def install
    # Disable custom postinstall script
    system "npm", "install", *std_npm_args, "--ignore-scripts"
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"main.js").write <<~JS
      console.log("Hello, world!");
    JS

    assert_match "Converted AST", shell_output("#{bin}astgen -t js -i . -o #{testpath}out")
    assert_match '"fullName": "main.js"', (testpath"outmain.js.json").read
    assert_match '"0": "Console"', (testpath"outmain.js.typemap").read
  end
end