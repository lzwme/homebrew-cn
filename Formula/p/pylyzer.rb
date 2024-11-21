class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.71.tar.gz"
  sha256 "7535555586aef9669e238678e12a7a4003d770c4dd57f1db3f89abf42d27944c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb75144621cb5cd9e865a4e3097333f918379467b872492bd1d49f5b41f12f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aee8a7f49a6c0a6b6019c758775c63ebc7478a8a71d5a2454ca65eaa83228cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd8e90797bf522f577842772a7cfba46695951651484da53c9ebd92b4d5dfa5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9740fdd461a3445e970c983eaa2b46343abbac63aec7f143e0ed1e7977cb68c3"
    sha256 cellar: :any_skip_relocation, ventura:       "a2dcf3cee76280a826da081a1bb5175a72b02afac111ca35c4f1f986c75d283b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83e772bf179568d440562829ad78c32119f07978b70ae9430986a7abac83926d"
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