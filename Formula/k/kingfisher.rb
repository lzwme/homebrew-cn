class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "7ceed4843b0fa749ce0db9afa64e2252112b826306cb74ee2da09277861cfdd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db648a4de2e0ad817c6e013ba8cec7854b762c668a3de3e97c4661f7aaa9dd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec14610b0051682dc4f0d1c34adb389000ed76a165d0d7b47d444d07eb5c425"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e50da30a953550fcb24c419e09d634c4844015bda5d7b552ca60695522f71345"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b7cdd4ef73d86a86c42739af4572007cabcacde3e71c3f994f0a46ad19b63be"
    sha256 cellar: :any_skip_relocation, ventura:       "c35f9ae8f0759d46dabf8f6fc470d226880f0b74a11733787190a923fb6c0219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36354a2d40bb18e911593d3ed44c506def8affe647695dd42c0a1a4942e4a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5367386de367d85298b83a4f0eeca856825b92abd08c7ca28ebb76c835f64384"
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