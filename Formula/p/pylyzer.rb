class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.73.tar.gz"
  sha256 "d232131d2db2d9d7be538773c80b0d4f267f125e4d7b190888448b1bdfdf88b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea5c5be1187843096a914e6495e18dacab2222a1fafc83437db60abce5635b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7bda770a6a6f7449ddfffa4895de1ee6fdc2d692e4539323826e943344e250d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f300a42a6baf17bcf8872242dd9ef6b92d742598e52bcb6622aef19bf1cdd58"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd862c5b24ee86d903cb55bed9aedecff19175e7e6160866ee299e32489ce0fe"
    sha256 cellar: :any_skip_relocation, ventura:       "a5895cf9e2f4a2be389b6ba822d6755c987f1a73e41b4c345f3aef9e2dd44ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2dd3374d05f19a5959b3773659107c641d36298f65183cad390e29b95272657"
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