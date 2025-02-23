class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.81.tar.gz"
  sha256 "80fcda681988adbc9c25dd44b4cf679465b0a54b1bd84d71fc4fc433fc1b2b82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721825b417b1b27e24a20a6060baea6a20f44ba98c200581491271dcb8e76013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "854990cd2cd716b2ae5c8fce3ff3ee687ab047e8e4f67df9070fc0de99bd484d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "020c4432ffe43b54e6be1d9932b2617b77a1f3cd10b57db81933c61176e915b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2a55fbd723fb7289aa1f7349a102654d0a70d13e4bdbc242d5c3a2503bc7e1b"
    sha256 cellar: :any_skip_relocation, ventura:       "feb9e056b7f3ab614171609d96ecd18c6ccee5f1a45d7ecf286128f7af42ff1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b985dbb387037df1d7103901c8ba4998a61598daa150a04e846522caad8802a5"
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