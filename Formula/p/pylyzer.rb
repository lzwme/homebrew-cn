class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.69.tar.gz"
  sha256 "e00bbbc5116c34372f222e3b1199b700df5e32d5fba9f42d6381542531849f85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b45953b301146cb8c1352de77c35a573d72a33df3f4cb77a3275855bad51a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b587a2eee33f7816ca4b0276128dc17714cc2b4f09064e6c3e43742badad6d18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "004579f113e2ee8cc55657cd3ad41ce35fc9603c18689ff3f9d8dfff93a37a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "4add20283d6c42a68fadc982c9cb137ac178750d88517534d90b94a0498026ed"
    sha256 cellar: :any_skip_relocation, ventura:       "d279d29a4b126d801c6412982056e4e1e3e1b681fb84ce9027f0d1f4411bed9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94512190e1be0c8130960a615f988411ef36df56ca35e70210ec63f4fa70ae7f"
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