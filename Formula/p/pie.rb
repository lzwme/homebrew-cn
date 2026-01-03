class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.3.4/pie.phar"
  sha256 "8685ff2ee3d5ea92fee292f11536e33560f95ebdbc893038634a220aa0acc43d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f573955492fa1227e112e1dcc1ef02be19eb83b87019fdd9303843f0fc81090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f573955492fa1227e112e1dcc1ef02be19eb83b87019fdd9303843f0fc81090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f573955492fa1227e112e1dcc1ef02be19eb83b87019fdd9303843f0fc81090"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aeb35634b6919e6fe2a3a7be07d2df196d5aa0be914891dc5ab8843e34b4bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aeb35634b6919e6fe2a3a7be07d2df196d5aa0be914891dc5ab8843e34b4bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aeb35634b6919e6fe2a3a7be07d2df196d5aa0be914891dc5ab8843e34b4bae"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end