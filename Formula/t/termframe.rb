class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://ghfast.top/https://github.com/pamburus/termframe/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "a355a4919974fa80c088adde8ecf56464bfdc8392cdf9f7ad9121f79f3350136"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2a2879f37c6caa7a50e2ec7ab260fbc262aa15840e243655cf44506b730a090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2d426c36b284cf2bcdd08bf043cc8d266f9e6bdfa099d5aa907521423287c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "102b003cd6ef4d7aa7a34a4bd7e0ee25de9b9e895dbef63abd4b5d29936d1547"
    sha256 cellar: :any_skip_relocation, sonoma:        "36e3a815cee7f0afbee2df7272c187195ecb3c3c2518834a403a05f6fe064ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "884aa74359876ffb264c6cfbb5577a037cdadd1094d7189f7eec5dbc4a3b9e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b8984a16dd28d7d234fbc193a441fea998d1039d54fbc03035794f176b034b6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end