class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.80.tar.gz"
  sha256 "8a783870c53ea40aa1c6558e2cfea826828ebf925a59a3c0c5d908ea9df9807f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d45435080d7e5e7391d5f4164809250503d00299661952a1b4a1d5b02e28cd70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c354b6e8546940a6cf82d992d744467be63667d3cb1c340782ec9d0d2d96d323"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e160d50dee647b09167bc5ab7bf34ed13cb33907afc54b47c3d25994a4f37eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fc314e27c04f0c90f028b0b508e60618fb0c47ea2c60b6cc55795fe73874b28"
    sha256 cellar: :any_skip_relocation, ventura:       "c66ba5da2a4f15b6dfaab5fe901fb2edcb0067cd4b58a75ce32441c8a9d25b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b63015c1fc66a845525da21aeb0f3afd3b711ae96e1c0e69e01ab2dc92cd007"
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