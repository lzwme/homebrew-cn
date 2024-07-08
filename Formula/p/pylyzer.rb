class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.56.tar.gz"
  sha256 "de84ab4abc9df8cd4dd6d5ef4f610e7444c7aee3f005e50a276b8590852138c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4262f158ce80528cd23d6e03c767f9110f72fc35939bc1e0fcc75f225b021899"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3064ad142b26ddcf7abcb599dddd23177e4fc7fcf786d635f118eaeb21b5241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adef73414592ecebef57c0a8b5f9a67bf2213a2e11f949f16f2324fa3c5afd0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9838067b8339fc747eabaf5adbddd1b5f238f38361e638338e6274b3ef1d8e6"
    sha256 cellar: :any_skip_relocation, ventura:        "f0bb847a9105d11322d102ce3398a39127266e7df0b9bace8f622edc77fdf072"
    sha256 cellar: :any_skip_relocation, monterey:       "368be2aabb3584570149dd1ca529e476fa3afb95910f4ad602b16d790620d1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3fffae0054d7c5b5eed5d74673089015d4381dbaee0702284f6f331775386a"
  end

  depends_on "rust" => :build

  def install
    ENV["HOME"] = buildpath # The build will write to HOME.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec"erg"
    erg_path.install Dir[buildpath".erg*"]
    (bin"pylyzer").write_env_script(libexec"binpylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}pylyzer #{testpath}test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}pylyzer --version")
  end
end