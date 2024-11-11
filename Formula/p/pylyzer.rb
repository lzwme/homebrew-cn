class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.70.tar.gz"
  sha256 "1b12e2c5366b74ea7d70d74474353f76f04939c346a32d258588cd9c201bd7ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ffaed87ec8c462455c9ff20f9528b5c8c26187eedf35070d02dabfe7f023faf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d2d2c2afcb7cc0a610502ff90607b312f29746e6ceaefe1252d1bfb80736e0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c5581d2b961f9e0e16aa9f647c5054ed7b02b9c88a4080dcb9323b967a889ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "83869704018cd0ad948b99cbcbd360c43aede34cbc7ad82bb218856e97d8c3db"
    sha256 cellar: :any_skip_relocation, ventura:       "6ff51e35f99adfae852c5426afcc7e0dabfe2361601a8bd3c3cfb74f6093ea27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "021f5d8e1269eda98413b3919709659aa0af163c0ca768941594a85241448f1a"
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