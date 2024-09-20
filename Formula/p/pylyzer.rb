class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.62.tar.gz"
  sha256 "05eac3d7e6363b0a8439003db5af30ddaae91cbbaed906321e109ffcb1c2faa9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09002e1ed8476459e75be4a6518bc64b838b53a801a1bd392ce1b3f8442ba384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be88f4f6da76fb5e186aba0e693ba5b095de2e3c5f0e8c92cdee8aba48986aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6097f7451850f1ea0e9c2c4d1bd6523730f39f3fd0524d93f6a629088bb31512"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b3deda0a2911657c7acc7c98b6911efa24e99bf1c2a8d02f1e13c5101a25927"
    sha256 cellar: :any_skip_relocation, ventura:       "a3520f17f46fd503b4d72af9929e8fd7207d5d4cbfe0c16d6457cdcd017ad6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e1f20aa27b9bba663551423e194805200d5e15562c06fea66de39c5fa1550c4"
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