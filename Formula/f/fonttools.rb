class Fonttools < Formula
  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages52c0b117fe560be1c7bf889e341d1437c207dace4380b10c14f9c7a047df945bfonttools-4.49.0.tar.gz"
  sha256 "ebf46e7f01b7af7861310417d7c49591a85d99146fc23a5ba82fdb28af156321"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0d7acf84069d3ab2aa6532d31cc833410665548ce7e79edfb18131c6f54215c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f69c6d9f9264e264d67d0d100f8dd5582d2faa29de9e471b72f95cc0ac6e436"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed25a1d390ce5748d60b1a560ef88ac7b1e509c92880ca6f8f02a240b6c10567"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0ed44a354e185cb91e1dffc3c9d2a26869a381dbe0320186f04dd805afd2712"
    sha256 cellar: :any_skip_relocation, ventura:        "e32de1c89a26aa2b3ede649699a9246ec5b4745d2d96fcb7845af6c47fbd10f5"
    sha256 cellar: :any_skip_relocation, monterey:       "b0e712b4280797f55fc9eb312c90c0069b7eae9f389ca10aed569667c9f0114b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302703d910a5705be423e7a6f1ed13e0679cbafe05753ff881252276ecff6ca2"
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
      cp "SystemLibraryFontsZapfDingbats.ttf", testpath

      system bin"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath"ZapfDingbats.ttx", :exist?
      system bin"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}ttx -h")
    end
  end
end