class Fonttools < Formula
  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages24d5c9e4706b3f564d8afe3005ccea1c9727a631efe790f8bb17819d12b192ecfonttools-4.48.1.tar.gz"
  sha256 "8b8a45254218679c7f1127812761e7854ed5c8e34349aebf581e8c9204e7495a"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a11bd11287cfd56866dd185e01747cf554be5002fcabca42ab7bd67503602a8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cafeeb86976bd7f841d738b066ed24692b974bb2f51be6cf58fcf2262808198f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eea44bf0da90b2a654e642af9093663245c90ce87069ddf72d27db6ed5fb249"
    sha256 cellar: :any_skip_relocation, sonoma:         "47c293ccb869f0257fb4565eae1dec585b52a3f92b672b9cc42ba041d0d353f8"
    sha256 cellar: :any_skip_relocation, ventura:        "bdf47273ec90e74edeabcf838b5875e61fea676422801e99fb6cf4c02dcd0fa2"
    sha256 cellar: :any_skip_relocation, monterey:       "5a252608a7e24b4833cfc9af49e30c5288306dec29658638151c666637d1f5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e94b8b7526aa66af2f4b36ecc7e440c5806357fd8fa3c5868dc948597c77f545"
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