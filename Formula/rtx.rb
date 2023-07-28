class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "c95180b7aa51d6812108d84965fda89beceb651a76751d26bd1f414d4da20614"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75ce763d9f4fc7ae8d63305bc7b9afc80ae8c004d334e8806f995293c9e7a688"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dc94eb98125cdeef1588344d762aa032c6e5cb1e31dd835d30a3370106a689c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45cd50ef6c07df316d3bfc449d14f2b9a52df54bcaf13802a31ce12acd9e0499"
    sha256 cellar: :any_skip_relocation, ventura:        "b50dd9ea9341f1f954572cd297f765545b022a410a210552cc2405c1e9549eff"
    sha256 cellar: :any_skip_relocation, monterey:       "77167ecfa560ab23ad062a7b7ff4c5de39329a77e9a7c91c99fcdb103486a666"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b7fb6aa05ec1f7ec08bd957fe629aeed6d4886d4a51458780497cab989fe301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f8123c256e711491a545f58e4026857b6b3a7d8b70264b2b2d42a1b7ea626b7"
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