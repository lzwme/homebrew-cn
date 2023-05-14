class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://ghproxy.com/https://github.com/rust-lang/mdBook/archive/v0.4.29.tar.gz"
  sha256 "13e2ff0b9193aa257e6629554bc7dcdb83ee9654235dcd351b254aecd7d7b04f"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "925f668d03c53b341edbb109dbb2c69930a6912e39fb307ca9460f511914cb5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00d2d9d924166b491df6b5099f61d6c523920cd5532e4a00ec486a8c8c6d685b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "614fd93d0bc48833859519c4be6db4cb9d654e7b52eb7a03459adb7788089616"
    sha256 cellar: :any_skip_relocation, ventura:        "c557e80336bd2369c3a06fa4dd8b7babfa6e15d68548672c1ebdaacc9d5e94c0"
    sha256 cellar: :any_skip_relocation, monterey:       "79dab2b07196bff1dd5d910e752705a1599637b11c727104596542104b7cc5d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f35f5565fac1b462298483322488c8a7f2e7e7e83b981e96fe947668dd23518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08629e55bb034f101705524699faf20ac52e029ba94060e229f341ae901107df"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end