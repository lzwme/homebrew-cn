class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.20.0.tgz"
  sha256 "372a861dc1663e25619c23a487aa716197c3b6bda774fbcf27850a64f69febef"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c8a5e3aad2f605943be0f216f34f8990ed772bca6e0799203ef8fb68600e175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c8a5e3aad2f605943be0f216f34f8990ed772bca6e0799203ef8fb68600e175"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c8a5e3aad2f605943be0f216f34f8990ed772bca6e0799203ef8fb68600e175"
    sha256 cellar: :any_skip_relocation, sonoma:        "20bf9ef2c42cabb69ec8c931aa496352f2af8a2498674ef42e8fc816c1b4749a"
    sha256 cellar: :any_skip_relocation, ventura:       "20bf9ef2c42cabb69ec8c931aa496352f2af8a2498674ef42e8fc816c1b4749a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c8a5e3aad2f605943be0f216f34f8990ed772bca6e0799203ef8fb68600e175"
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
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end