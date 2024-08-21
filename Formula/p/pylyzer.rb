class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.61.tar.gz"
  sha256 "fef6872880b51353f33513e8c1b3a94a8981dd702c8b1b452d1ea39214677ebe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ff10eb6de4ad1d6bd154d4800cf28f47898ead88f8b1df110b1ad62705048b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f55bddced3c3fe3a0e8365c71edfb23d8af84c40d1cc2f82af52fecafd24f211"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7f15fd85eb6c65292dab383439399a5d99c150be4a1b33e40c3670c1e19416a"
    sha256 cellar: :any_skip_relocation, sonoma:         "08cd9852d3de9335b37272f23936b178912fcff303c273ffc5abc6395cf9d538"
    sha256 cellar: :any_skip_relocation, ventura:        "910dbb6132d9d90182df1c2d07efc64f650b597bc8c1820f9c4d782836dc571d"
    sha256 cellar: :any_skip_relocation, monterey:       "07f6e3ac44945e6ab72edf5a279aa854d047b68cc1e1ade1db606af9bcd2e020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "652912b27c5a3ce8bae40ae65f606dc54dfe1e3e3deb49f8a37d486053b8425c"
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