class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://ghproxy.com/https://github.com/printfn/fend/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "9e49aaaa711dcbdad0fa68fd9c9b3e25a8ab4db57e941d6ec2060d8ae331e05d"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e3ef0e4b8bb1962bb7787a0b5e4c4f84a7fe0928ad1912ebefbc5be2df1b37d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4db7fef5a467c2478bd307be8298559d444d96d80d61ddcf4d3a1bba8f895af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef0825ee701d042147dadb5702073ff3fd993a7afbd79f4714bfd5e48503f504"
    sha256 cellar: :any_skip_relocation, sonoma:         "5183fd4947275276017c6b407298d7eeba75636af2a0ee8e9326970283d08195"
    sha256 cellar: :any_skip_relocation, ventura:        "f0b2ead81b7f6ee6d9950593b6f068b7714cfa790d5c8977a94b6fea77a36352"
    sha256 cellar: :any_skip_relocation, monterey:       "a31c18f5209e068f387fdadb6656274a32c39639b00a45a854b98bd5f5c355ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbac2450cc5d9230048b39916a40167671bfba173ddd59c464f1f676d4d1d5a"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end