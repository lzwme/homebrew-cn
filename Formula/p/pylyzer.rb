class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.64.tar.gz"
  sha256 "9288ebf9d6442764d3f5761497c62813a3590094b2c56032741a51d6fb9962c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a6c67f2445ee7c055b305371e60cee54bded73dd6c56e0ab133a30fc226223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e68f32a3eb4152142ab5ec9ce94ba7c3360bb2f22eae9bb342ae04a1d22f2d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a487209f45dd40f8c69de0d854ac8297d3d0463badda475ab7f4850564f265c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c8b3976d4250a5ab07a398aa12d39efa939f9fef0d44e6c24e96456d3450659"
    sha256 cellar: :any_skip_relocation, ventura:       "bddc4cab1da399cef529fbe00abaa76d406efbe9757a9aac69e629c3cecedc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6162c2ec713b9c0e5c05495659050a6153eaf14a7d828cfc9a1ff3885e154d"
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