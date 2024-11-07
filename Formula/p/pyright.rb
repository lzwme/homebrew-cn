class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.388.tgz"
  sha256 "f81e93b5b9073d1a4d29e5b29d5a4c6490d1746af1e5b4f664c42225ae70b593"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80983bf84c93f16354b790a991028b2057eb41a7e5ba7a62dce16ba74b41012d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80983bf84c93f16354b790a991028b2057eb41a7e5ba7a62dce16ba74b41012d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80983bf84c93f16354b790a991028b2057eb41a7e5ba7a62dce16ba74b41012d"
    sha256 cellar: :any_skip_relocation, sonoma:        "94e3903b7acc19c635eb51d7c6d68a357728bb46e4e2586ad4decfe1db63eba8"
    sha256 cellar: :any_skip_relocation, ventura:       "94e3903b7acc19c635eb51d7c6d68a357728bb46e4e2586ad4decfe1db63eba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80983bf84c93f16354b790a991028b2057eb41a7e5ba7a62dce16ba74b41012d"
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