class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.8.9.tar.gz"
  sha256 "549c7d50a9d0ddd006f9fa787ab50837615e3efeba0dc073e8e81199ce754cf2"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f38d39f32773dc85a7bef3a3fc2ce1f72a18c15541eb93f4c70713ecb100b86b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de067fd28d92f15d2eac8052adaa04d8f7af29cb6bccea9d4264173cc05cd6e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94c00e6d344dfeb9b6397623d91c4694d3d9f963d065744a4248c9cafb7c2582"
    sha256 cellar: :any_skip_relocation, ventura:        "f725956400b2b4713b55bb03a75eae98c15596c9b668a58997246075316db53f"
    sha256 cellar: :any_skip_relocation, monterey:       "15a69381ded54c0776c0cb83feb87f2e20c8f57427e291c18fdf3f72f2951766"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b72e7067bc07152f1aaf7c4f0c1636638d701e71b7a84cc8bd666520c17845f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59178e83bbbd2a79ea6c3e5ba1c603469a8605350150b778481504298514136"
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