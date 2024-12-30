class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.76.tar.gz"
  sha256 "e6e60ddcff14ec57e13fd810f57fa105d5ce5a1795fbe58c37684d69dcf4c52d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5d70d07ccc4bff79c3c600a981e83fdf3449d6de209f6793585338f342607d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec02a0b5e112568b63dfba1270f6158025c6d112e24e995757e0734380889d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3780b1549ad07bc77e1b844249d6f019a67d644752d86a0a85eb64e8abfd11d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1a3c112c344dc622e40e5d8710ae236a1e6ebfce288fd3e5cd014482bf605bf"
    sha256 cellar: :any_skip_relocation, ventura:       "cd20497670ddebcd32b92de5e369bba9aa19bf6b37aa0f461c2de5fa84d85676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2b2a8b2c33a83242790e0f0bdd5ec718c869dfd275810b952f7f7c8b13fd252"
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
    (testpath"test.py").write <<~PYTHON
      print("test")
    PYTHON

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}pylyzer #{testpath}test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}pylyzer --version")
  end
end