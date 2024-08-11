class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.15.2.tgz"
  sha256 "c9e0dcceb4c09c8a5426eb544c1c1991fd27415f313c12e594e1c3373bea6aa4"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a66c0bd2bfcba23a6bd5282d842d46b59c4c22649f5375d20190c5bc705528e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a66c0bd2bfcba23a6bd5282d842d46b59c4c22649f5375d20190c5bc705528e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a66c0bd2bfcba23a6bd5282d842d46b59c4c22649f5375d20190c5bc705528e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a543f717f6d1b525e61a6bd6e6d2a635be5ca30120c4c83fa23804d65358376b"
    sha256 cellar: :any_skip_relocation, ventura:        "a543f717f6d1b525e61a6bd6e6d2a635be5ca30120c4c83fa23804d65358376b"
    sha256 cellar: :any_skip_relocation, monterey:       "a543f717f6d1b525e61a6bd6e6d2a635be5ca30120c4c83fa23804d65358376b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66c0bd2bfcba23a6bd5282d842d46b59c4c22649f5375d20190c5bc705528e2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binpyright" => "basedpyright"
    bin.install_symlink libexec"binpyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}basedpyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" is incompatible with return type "str"', output
  end
end