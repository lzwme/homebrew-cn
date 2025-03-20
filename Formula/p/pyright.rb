class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.397.tgz"
  sha256 "b49423fd56f4ed032b89a6ded15a740f0920344649fff431c9777c6331fbaee6"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef0298a3cf6894e332f68f4904c637f78abc491564595febd4148af15b459439"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0298a3cf6894e332f68f4904c637f78abc491564595febd4148af15b459439"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef0298a3cf6894e332f68f4904c637f78abc491564595febd4148af15b459439"
    sha256 cellar: :any_skip_relocation, sonoma:        "d92dd2414b7727e8ad039552efd089566b4a74cfe44d8c6d5cb932b8d89db018"
    sha256 cellar: :any_skip_relocation, ventura:       "d92dd2414b7727e8ad039552efd089566b4a74cfe44d8c6d5cb932b8d89db018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0298a3cf6894e332f68f4904c637f78abc491564595febd4148af15b459439"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end