class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.1.tar.gz"
  sha256 "94c0ad9fff1ce648d831202ba65789dc13fc99bac4ac21caec3340b28d5aa73f"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7e0d9223eec8e7c44faa4391f35287784884a1e3dc706be8c75d1e947c3acc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "715b9e9083442a4a449eee35849d3e3c3b3a59b57fe0d2f0b17ff05ff10722a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77d0a0fbbbafd85955e4c8013c6f59b2dd18ae6833a4a9c06464ebb8b516ac19"
    sha256 cellar: :any_skip_relocation, sonoma:         "85366666e6825afa89295976375d0154579951baeb6bd05b686b5e976e641c16"
    sha256 cellar: :any_skip_relocation, ventura:        "93bdcb85e1f0f69896bdf5cb5b2874a5dfae453a82673bcfb35e4897f91ec8db"
    sha256 cellar: :any_skip_relocation, monterey:       "d10637caf216c85a540dc819cfd24b59a811fda9c2439de701e54c0c1ceaabda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e08a9e680609100358a79dcf035ed1398c8f615b11f66875710547524a12662b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

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