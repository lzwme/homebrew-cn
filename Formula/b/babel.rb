class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-8.0.0.tgz"
  sha256 "aa9a8ed43f3092864cc21b53f569061d4159910e742c6cd51c40e7b5b1f924fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51106a43e4adca72cada31f1306d0f05e498eeb5735d2337afa3105ce1586b17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23a723b1843937e7a170d1fb916b6d99903e174ec8775617334ba2c4a7584cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23a723b1843937e7a170d1fb916b6d99903e174ec8775617334ba2c4a7584cd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c5af2b6bd116a0dfea292f129f8755292667ea7fa074e980deb37cbff6197a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c5509d8fb49d438ebde6b4c0bbe21235a8918a16347c0f3292f61db6fc5b334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c5509d8fb49d438ebde6b4c0bbe21235a8918a16347c0f3292f61db6fc5b334"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@babel/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    (testpath/"script.js").write <<~JS
      [1,2,3].map(n => n + 1);
    JS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_path_exists testpath/"script-compiled.js", "script-compiled.js was not generated"
  end
end