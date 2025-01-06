class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.23.2.tgz"
  sha256 "f8e47530497f165a9790363aa0d860b7de07ea13060d56e2546e2cd33c8c7c27"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b102903f8ba45c797290e10ed329fdec7d7a60836f5bc8c58258d9f8b03e9837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b102903f8ba45c797290e10ed329fdec7d7a60836f5bc8c58258d9f8b03e9837"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b102903f8ba45c797290e10ed329fdec7d7a60836f5bc8c58258d9f8b03e9837"
    sha256 cellar: :any_skip_relocation, sonoma:        "25cb700edd4a0ea716869ba60fd0fb83a2d0877239c6a769fba6e7ce3cc19e11"
    sha256 cellar: :any_skip_relocation, ventura:       "25cb700edd4a0ea716869ba60fd0fb83a2d0877239c6a769fba6e7ce3cc19e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b102903f8ba45c797290e10ed329fdec7d7a60836f5bc8c58258d9f8b03e9837"
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