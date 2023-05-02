class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.29.3.tar.gz"
  sha256 "6805ffe01f69ed8b439958fcd6047e47b592cb476befff98df5941b95614eb41"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8831b903db018af2b532185e46889faceaf9b5a1010af5e70c5d0fb3eb5e48c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "025ae2adf2f9b6c4dc05cb80d53b3d33f1d6bb7d5d29e4dafdcd1ff5f2a083ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b073d50a595a2ec5ea90258239e864482b4e6ab32be30a565895bb0774fcf429"
    sha256 cellar: :any_skip_relocation, ventura:        "93b4e753c7ff59976795b5505f9c5a33de5124b55815877446eac187f41ed6cf"
    sha256 cellar: :any_skip_relocation, monterey:       "b14d007e416a10f07d670c7a310cd2cdcd9c2b413bcb57256b8b0d5bb1969de7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f1028d997700a783ae04e33476f9a52751658e92789bca8f7b71c4c225ad7f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0b48b7506e3e694f6266350868574db421053876b3312ebc12db07e1fc74efe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end