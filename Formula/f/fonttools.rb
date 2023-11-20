class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c4/9f/9c3c66017e2be1aa04d9ae54936c932b1e3ad09f70987a9b8a9a2c71ccaa/fonttools-4.44.3.tar.gz"
  sha256 "f77b6c0add23a3f1ec8eda40015bcb8e92796f7d06a074de102a31c7d007c05b"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c47129bb932ddd84c20b48d076fdbf0ff361a8394e4fd5ec6277110c0c58ee40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76fef3f93603d18a7bc2efa4cc3469491c0c5c45520a98a052fe50ae82472201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ab92830f175d6622b8fb880116820a8b8406e2978500bcfdc89b523da051c4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "60274153c942146e1be8e82097334be8703e1c7e5f7ffdf104af5ec1b97735ca"
    sha256 cellar: :any_skip_relocation, ventura:        "f7bf3e5aa05c9b9edb87522e6ba077a0d09a2ef830bea7d29707af216e29344f"
    sha256 cellar: :any_skip_relocation, monterey:       "db82f5edc1670867144d1d95aa059657ab07e5ab31db82b264adcf083b133045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aba42632458d16451fe6a55f7379b298eadb5086834d7a6143ea3db0d220a44f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-brotli"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.ttx", :exist?
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end