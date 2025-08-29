class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "38dac009509d547ef292368e7b545e23069cb9d6db9ee6272d06ee3e12261585"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41ad137510c5520243264faa172ed9f1da9f786beb2e4fd7eda57653c5276a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "379850e1b6cc1090a5814b91d0ddc8a07392c7cfd27808b42442e9e51fcab893"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2314239dd27750dee2f2f8387e2ae0e0ae00d107c5ed6885ec5820b9bf191a01"
    sha256 cellar: :any_skip_relocation, sonoma:        "430231b37bd0badf16f0b06d7582c6d3fdd3b60c4a241f0c118cfb499349c3fc"
    sha256 cellar: :any_skip_relocation, ventura:       "288fe01a72e051d7399c2dd1a09ece15a47bd2cc9ffd3e6cd7635845f02818aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "074a977923e7c4b7ede006ff27615dccd7500c23ef6ef775366a5d016e15034d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2085d779ff9bc4da5f2d5df6a45f938a9765fd3fbf08b09c181d9e66643dc418"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end