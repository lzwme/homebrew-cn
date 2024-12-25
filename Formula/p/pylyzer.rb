class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.75.tar.gz"
  sha256 "fbf4fed387cbc37f0fda57960fe120c718f35a4616a725a26c754dcb45a57a0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7044cab9a95e8712f2aaf1a16557a3c556b7256aaf0cfed60397f64e93dd7a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dec6d7b437c29ef4aeb4848a3fce921de82f8abf04b0960e42a1600082902dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9014cd3816cd0480b42353f2a0bd3d3c5a561c5d2688605dd299b52718586fde"
    sha256 cellar: :any_skip_relocation, sonoma:        "40a4319621f2a5913adb9d4ea9e3435bf1fd8df8f4ebdc29d7adfbb29df441bd"
    sha256 cellar: :any_skip_relocation, ventura:       "5e53288ef49bc0dee205fb80f93f0c66fa66ba6e6ef6b5fda6bc02ead74313d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f283b924ee9dc2c8c0ccde5affa65973a34c505b508401a4b8d98929a2496fd3"
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