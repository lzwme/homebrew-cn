class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.79.tar.gz"
  sha256 "c112a9cd5dd0cdeb3ccbc07f66aafdc36159b5a0482610270c46bce822f50e79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80b35f5bcc4ce9ddfb992259c79000055a916044cd97cf09acb532f50cab9271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9c235283ccba319dff2c2fe9204759a633a4cff7cc3e9b066f1a1a7a59d272d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1dc4bdb0b269631680c4d362b1b6c666c077dd193d5e622c06ee34fe7403b72"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff164eebc98cd919642a91f06ca4b5861cc93ce7e3d893b7acc7eafc933e0e1f"
    sha256 cellar: :any_skip_relocation, ventura:       "5e82fb5b005e79d69e133cafea2178fe6ddca51417cf1a3baef53de7682e5998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b1f6ec7e6ff15a565ce99d8de7a0906e4591f4e6cf6503c4b903b286db276fa"
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