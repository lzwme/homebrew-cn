class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.58.tar.gz"
  sha256 "9d21293eb5daa98f6d6fcc098157df84663f2d149e4a9a3eb77c4e1becb15d81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14447a7a11ce863cb23b2847914c4a6cd322234779fcfbfded5fc20211e8c728"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "886cc1cb38fa7d19315b9914a05f6d1db15e2281512bdea69c9c506272b9772a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76226aa940547a8a87c69c14c4a8738edb5685dda6b083b60a7a482f8399ab57"
    sha256 cellar: :any_skip_relocation, sonoma:         "e39e43db3101843ef5c245930a14ca9c080372f229ff3579ea92c27f796e4f02"
    sha256 cellar: :any_skip_relocation, ventura:        "51671a78a46a49d2db3f539f95daebc16e754716cbe7bc463a427af2f8c8300d"
    sha256 cellar: :any_skip_relocation, monterey:       "c70cb3f53938b3d7f3e72096a33b1b6aede6d43e1d5e46a889c704aaa62f0182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8ac8f57cc13146c38a699336e0cccad6b9495cd74726cdb463debcbd4643dc9"
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