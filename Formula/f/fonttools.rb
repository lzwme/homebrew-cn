class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/96/4a/3f4dd4017148aba83375c56635cf844e91110468ff70d5762cec80677b7f/fonttools-4.45.0.tar.gz"
  sha256 "c1c79d7d4093396892575115c214b24f09e68997cb5c0ab2d99bfdaff74c64b6"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b6d0da4ea3d5c0881ed0d68dcbb732baecbefcfefbcc3ff611ce6ead596df51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8631bf435bb9ada325e1b22ff7ff43afb99b520685e76f03ebabc83ba4bc6a25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d01a0f79dab6889f7f934d81fc66a55753de94e8341312f69d0a27c0e925de54"
    sha256 cellar: :any_skip_relocation, sonoma:         "26dc4cc37cdb222dd10a9ac27bdc634ef6139c2780e117b9c3626dd0ec88bc2a"
    sha256 cellar: :any_skip_relocation, ventura:        "0e675a1ff9ba49f9cc31b7faaff238e3e92d1ef764769e16b4dbaf82743d1b7b"
    sha256 cellar: :any_skip_relocation, monterey:       "169c577d276e75f448d8ba957bb875b534ec4a09b5b3a6b2aeeff6c6b7d18a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22d913f4a36e78bb1502e9d4679e89aa2ec800e531ff434614e36f9bacf3b75c"
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