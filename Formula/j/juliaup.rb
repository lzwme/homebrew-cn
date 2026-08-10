class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghfast.top/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "b31d9ba4c9cc29ee037004754a0fe3c72ca5bf2b2ba6934baef9966e4240e943"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35168a679fa769ffc1ef7859075534657c4df7231b79c0fafaa05f608e04cb0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61a702485b2e464ea46725ec51bbe206c7efbf9598878bf853b6de70d01efb9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de93986e09ef929d6e22ae53e4360ef269c107bc0cd72dc33e94184239679442"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dd65749630cd63cb50503132aa54961c3a574db50d9be62a3744e8d0055a236"
    sha256 cellar: :any,                 arm64_linux:   "0bc689c3b1b2e10661c3491088aa1f3b2db72ce04e07a3b8cf020243b6b9a1b8"
    sha256 cellar: :any,                 x86_64_linux:  "1b8c2bad2559f780de014e535ed83a43abf1ed1ac75d1d4bb283b6f73142a763"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end