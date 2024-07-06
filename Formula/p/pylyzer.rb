class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.55.tar.gz"
  sha256 "3cf1a1bf2e5a248c8d9bfff5de8c3a1abcf5c94906a5b2bc01744a100685aee6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0fbfa6c09e247e46b8b82564fd4d9c511ebfe4372d46d0cefca885e8b5018d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efa771bb8acf51a0851d013f28a001af552d29b631e3495ef1bcabd655b0b7a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3f3e26a3844345b50dcaf62da5925d7616a7f779dab947b4b5f6c5a4ad36edb"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dbb40d5c25a30228f37614decd8bad1c8aee37d552eb40ada8f06d948c9db47"
    sha256 cellar: :any_skip_relocation, ventura:        "086c39f8c24d05eaa8378b379d6e8293924f38d7ef605cc88e99086777beda8b"
    sha256 cellar: :any_skip_relocation, monterey:       "bdfc353860098501156e0265b20f951e20c350693df85016651526d3ea584eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d51d65f8382eca104c206bb71a669cee3332a3ee52842b9382dc433bf63b3853"
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