class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.74.tar.gz"
  sha256 "c773aa019ab32e833cabb08490eb5a849fc7268ac3af29bdb54b32ccddd344e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ec65f15f1f7004cc8f032edcfb694838d522f5944faaae4e990bcc4492fea50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebff5b978598c4f7006fb0b5a6d0da08e50b65bd9c7e021172913b985d006752"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05febbd9fd7cbfab7f1fe8b89a28c4eb168cd766d4d11082678e33ffd000f8a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5ef6f5e7226003dc479f2ba5d22337dece35d74f8aa1d2bf07b9d7e169268f2"
    sha256 cellar: :any_skip_relocation, ventura:       "4077c6f8784b107956e3a04123901c1cff9d9358b3a1367f856c17b3bf3aa0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cb523e0f35b813d422b1d3191a35bf2a300ba86f9bb31e05d65639b0ee99d72"
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