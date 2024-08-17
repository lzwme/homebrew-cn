class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.59.tar.gz"
  sha256 "4613257a426e14672f000ecec9f28bf3d5a500e6f1f019f1d91418ed43dd0d5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0704fa2699229adfd7e679bfc889149a9d2d839e357a42fd36335307fe61b86a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46518f56b28f8b7509fde59d578f097736589048feed8b3eddf105919b502acc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4620efeec2566cde517cc9743c77d2efdc6e25601042693d7b3dd2a534db5d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "482fc9ee00b6eb26ba34f85876a6c54ade9e4a692455731400495451cffaede9"
    sha256 cellar: :any_skip_relocation, ventura:        "8416e1bcba7ecac35ba7dcd2c5ebff44eee2ca39bb575a70614634876bdd109b"
    sha256 cellar: :any_skip_relocation, monterey:       "7b278e1794339ff854bdd6e6720514f8838269bfa72c43e34df31b53d396f4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02497cdfa469a075b1b59062d35712ba2cc803b1ecf18c3294632afc6402cc8c"
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