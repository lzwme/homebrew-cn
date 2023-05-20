class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "4a17834a653eabb4efb7dee60ce50f51d4e4a39c00ed8496037a6d26a70d38c6"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb40a265fc32876f258d01cd71d1d60d0010be12a063d3d00fa35a8c4b9bdb25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eddb623f5b57be6e6c85b7029370feed69025f1c49458fd50d1ff9cb833349e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c029e832a3b26e88a1ebfbb5b88209c4e1373a85d247db66919a63b5448bf18"
    sha256 cellar: :any_skip_relocation, ventura:        "b9ffe81de94a93c8abc2502ec6b6bb92a3f2013cb9c101f22698db13fe5998e4"
    sha256 cellar: :any_skip_relocation, monterey:       "30ee70b37f90a8fa8484b6582aa3b6301b114cc536363d4603a02f59ec602efc"
    sha256 cellar: :any_skip_relocation, big_sur:        "47752dd6532f64a20a3a54f66914b0c79e4c0db3d444ed15380a6dbe4e06a488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12037b157dbeb3afbaeefe7b16f78a19632d2f3579ef60cb351b222b39806bdb"
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