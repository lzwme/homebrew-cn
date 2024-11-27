class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.72.tar.gz"
  sha256 "ae4f7e855f4102977d843003adf70801c77740c028336ca3da1c975bd538ea45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b08f06cd7e2bce7cda6fba4792deeaca78bbe97506012e1d4e662061525909d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ac19e9380de4d4d61e4b0716e88cf97f9ab9ed4dc2cafe756b758e6c61c7cea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "570fa53a95b61859b1be57a4db997a0d683f16bfd0b09444e49a2759955df239"
    sha256 cellar: :any_skip_relocation, sonoma:        "a772da8d9fffc1b56d7ec5634a93dac63af9da385d9f0f9d9d17e203cb6a8143"
    sha256 cellar: :any_skip_relocation, ventura:       "5029f6ae0ac9f85299baaf346711f0cd11873b2c642cafe7da78e3b2f61c9c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e439ce06b1104560bb5473dbaa6e9916d959383c187749a4b8a235590c6f53f"
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