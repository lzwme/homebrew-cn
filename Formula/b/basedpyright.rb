class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.39.7.tgz"
  sha256 "5b610c239c344790029a7331bbc739bfb90cd7ecae20b3931074e91a5f5583e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9b00c8bbdf840b1e64d96953af2f17465a329198ba433dfd5353ed0ccfdf297"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"

    # Remove empty folder to make :all bottle
    rm_r libexec/"lib/node_modules/basedpyright/node_modules" if OS.mac?
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end