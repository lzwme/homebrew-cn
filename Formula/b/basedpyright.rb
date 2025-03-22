class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.28.3.tgz"
  sha256 "c36c4d082fc0dc5864742e6584e1c3e54daea858946cb4720a4bd74dc47fc063"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12d58ccd9503ab6bc44a02dcf594a628e3e4e90f2e8d20ccee370dd74d9f18c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12d58ccd9503ab6bc44a02dcf594a628e3e4e90f2e8d20ccee370dd74d9f18c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12d58ccd9503ab6bc44a02dcf594a628e3e4e90f2e8d20ccee370dd74d9f18c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7801cbdf6869802768945c0640d4439f9b4287ed792f32cb07069875ed5baaf4"
    sha256 cellar: :any_skip_relocation, ventura:       "7801cbdf6869802768945c0640d4439f9b4287ed792f32cb07069875ed5baaf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12d58ccd9503ab6bc44a02dcf594a628e3e4e90f2e8d20ccee370dd74d9f18c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d58ccd9503ab6bc44a02dcf594a628e3e4e90f2e8d20ccee370dd74d9f18c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binpyright" => "basedpyright"
    bin.install_symlink libexec"binpyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end