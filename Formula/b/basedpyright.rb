class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.21.0.tgz"
  sha256 "d5b4cccf0e016937154c5cbd9d526c21eb6b17d61d22b88fe0da2329061369c7"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b3fc437bdc9cfd2913b70efe4c22111ed768506ea22b589273cf37ccadd38b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b3fc437bdc9cfd2913b70efe4c22111ed768506ea22b589273cf37ccadd38b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b3fc437bdc9cfd2913b70efe4c22111ed768506ea22b589273cf37ccadd38b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "70f0f7a9087d4ab5bb1dd1238cada677daf420b9fe284a125df1183b925acfd5"
    sha256 cellar: :any_skip_relocation, ventura:       "70f0f7a9087d4ab5bb1dd1238cada677daf420b9fe284a125df1183b925acfd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b3fc437bdc9cfd2913b70efe4c22111ed768506ea22b589273cf37ccadd38b2"
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
    output = pipe_output("#{bin}basedpyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end