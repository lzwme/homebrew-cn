class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.379.tgz"
  sha256 "df7d4477fbc28a8ea85448b0feb6cb06672a3a49b59b5bdf9715e27775b1af14"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b56102263fd3fdec25f01561fa11e607cde576a3b0103abb17140ae99d7ec0f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b56102263fd3fdec25f01561fa11e607cde576a3b0103abb17140ae99d7ec0f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b56102263fd3fdec25f01561fa11e607cde576a3b0103abb17140ae99d7ec0f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0af3666b98c7455fc429dec70a6482dfac598ebca9ff48fcb2993cc6ba5b411"
    sha256 cellar: :any_skip_relocation, ventura:        "e0af3666b98c7455fc429dec70a6482dfac598ebca9ff48fcb2993cc6ba5b411"
    sha256 cellar: :any_skip_relocation, monterey:       "e0af3666b98c7455fc429dec70a6482dfac598ebca9ff48fcb2993cc6ba5b411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56102263fd3fdec25f01561fa11e607cde576a3b0103abb17140ae99d7ec0f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end