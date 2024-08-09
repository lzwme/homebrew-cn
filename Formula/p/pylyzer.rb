class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.57.tar.gz"
  sha256 "1d3c425672e06d6848c7b12e94978275e0e54ea221e5f32a3131696dfe076448"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dc415431e7257f59118e4928d829c8024e9fd94f39559c25d0ba0ca1a82fbd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b799d3e7af9833189bd6a49531a4b1f6e2c091dd0eeb74749f271fdc6a0d6186"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65164625d6e27318ca47b9eddc2e4db4a152a3708d780f825ec1f7af3840cdee"
    sha256 cellar: :any_skip_relocation, sonoma:         "10d555e02c49789af40b6e446f7796e03803ac4723f7081cfce14018bc5b140b"
    sha256 cellar: :any_skip_relocation, ventura:        "440c53eaa4e24151cea86a7bbdb37c0efc3ff6ac51d166cc847e07373bb33146"
    sha256 cellar: :any_skip_relocation, monterey:       "774bfedb9abfc5e1dd550299ca25bcb5e5a5627ca26e67d5ba649287e7a8925d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de13f863ff2fe58be7cdb7dadbba0234f4bd6b230e9bbb3812bedaf21f24cbec"
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