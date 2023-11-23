class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.11.5.tar.gz"
  sha256 "675abf0534b5b775caac6bf1098dad87d26a208b35510fd3f11f6cfcf9224777"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a400198a4b4fd011cc94ce2f08fed7fcea6f0bdb5cf6a31ec91e87ef32aee79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6958fc84a53092229c0939dbc68b5e1c28541166c6faabd3dca2b97fe2938896"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15c8e88493b377beef706e3864f64f55c0d028636b5054e2d67e44133b6eb9b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d5ccf2d914d41650874ab0af853d9ac2fd43ee2ede58e161a71b79d3c167fb9"
    sha256 cellar: :any_skip_relocation, ventura:        "141348e83ca791e8f4464c90fcee0f8f8ed40bac2755854c65429b7582bfd7cc"
    sha256 cellar: :any_skip_relocation, monterey:       "b3d7dc1f86f64dd9104ac8524ac1ca1e53e2b2631de221429b3ce6bde9d3de02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b6fd3747727dcaf8b61bea4e323157ce4674030d18c10775731369800793f71"
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