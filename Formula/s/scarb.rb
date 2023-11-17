class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghproxy.com/https://github.com/software-mansion/scarb/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "24bffe588cf521591512f67dcb45f2cbc391ff47c76339b236556318e2b85281"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f896be01d7c4ab4215f7b6a5b054cf304729163f0108de58c3912c0bf27b9f45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d4166f1b103e129b26f2cb743d735437aae00489f9d9d759ffd953e8c7e7c94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a816a7d199df01629f2cca290f9249510c331f7edab758d749e955791f001f7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "49be282cff5caae8eea881be7652580b9e84fb95e43117bfbfe6e1c3cd1ba4b5"
    sha256 cellar: :any_skip_relocation, ventura:        "a4a965fd736f871176d884439abdf6c3941f10cd88e9ef42cb0e5a73d858e8bb"
    sha256 cellar: :any_skip_relocation, monterey:       "6ad67a1b077f30b00afff7afa7157f63963c7a3b2af8537493e4f585c4b1c2c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1f9ba4144402cf840fd92774ce9e7201c67d6095e20dede9ea712fa3ab027b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scarb")
  end

  test do
    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system "#{bin}/scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
  end
end