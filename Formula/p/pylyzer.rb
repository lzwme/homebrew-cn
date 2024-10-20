class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.67.tar.gz"
  sha256 "87fc5ea5c090afce74755cc19132d07059c9d8cc264ba3c6ba47f33f4b738715"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8439ed97be50431932dd02858c8a005730464bde5995e8edbed3d40df5a8ee48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00137e6e27ca3f8682a48a363374f2ad4459b6656627288f03e179fc03c151be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a67a40f80861cf67a056fca4055ce703ec05f8bd90a7c6dd3190d0a1cefe754"
    sha256 cellar: :any_skip_relocation, sonoma:        "e52e6e22df55bb581e1b4ad9808216e67ffec27a3c8d4dc29eff266ab9c947a7"
    sha256 cellar: :any_skip_relocation, ventura:       "719d29aa6cee58a1a447819efe83e12ba8b49cc0467967e1e5f381d8ba8206c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b90efe1fa565f22097cf5182ff2179946f1e1ad4d63d8383edda2cad0329963b"
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