class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https:github.comkornelskidssim"
  url "https:github.comkornelskidssimarchiverefstags3.3.0.tar.gz"
  sha256 "2423413fc24295928c1fc04625d24c54362a5473276effbc560a3e3d9ad349ff"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fbef156045e436a749750b6cec330fdaa2829b3e2f13c01bf4fbc0930f671d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da5130c05b493861a3a3a46e5ac942b8a5f63ab7ba57b073103cfafa96c6d4a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da16685b6140f67c5bc2c47f96481dbb180529f307f29d9eba6747d8626d20d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e39edf5f84279bcd99324547f647ff8b60e47a61aaf34364a1e09d34324e0b07"
    sha256 cellar: :any_skip_relocation, ventura:        "f082e73edf609bf5154907ee3bbac4a0e3b06cefde3f8116b27497de70cf300b"
    sha256 cellar: :any_skip_relocation, monterey:       "4e4e634f9450a6150abbd00bf1a6c81408adae8e3ab2812b65f6ff5d9edb5533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20b40ff449e832a644b3f1a64e3785bb5cbaa93dde81910c046e908ae1995a4b"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end