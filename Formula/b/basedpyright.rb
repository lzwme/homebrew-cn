class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.19.1.tgz"
  sha256 "1ad1e185dba76916e5fff8835be916df2f743dfebba3b8d4a27d576cd8e246d0"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13eaf7187296d03b12699508d6eeb9495b9f4592b3bc8d8a811425855c75d98c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13eaf7187296d03b12699508d6eeb9495b9f4592b3bc8d8a811425855c75d98c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13eaf7187296d03b12699508d6eeb9495b9f4592b3bc8d8a811425855c75d98c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b27f54047f51eeaef5c1b2fe32ef47ee20f6cc3c9edab536886cbb9f37fd33d2"
    sha256 cellar: :any_skip_relocation, ventura:       "b27f54047f51eeaef5c1b2fe32ef47ee20f6cc3c9edab536886cbb9f37fd33d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13eaf7187296d03b12699508d6eeb9495b9f4592b3bc8d8a811425855c75d98c"
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