class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "d27087c5c7d096a77645a995112d95e4ccd23136299348053b335a1a621a3b1d"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1389b825a70e909e7d850ca6cc9a52a2a0aa8951a087c7e756954b25ebfa4484"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02cfb6445f2d5eee44834bfa2949ff44bf4cdda9ef959cf9f98d836a9d3024e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eff3a6db7314b391cc6efdb71e22ffbf21d5748c891f9576055939d761b40f2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "12fca3a8ea04af75c7c6e8b76a40d14729aa252983ace7316b81986b74b4bcb9"
    sha256 cellar: :any_skip_relocation, ventura:       "859407d8f2c6516c08c0e0fdc417286226b55529ccd310fc350c08415048e2c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4b1a26591c86733d0cbaed1534bd8990d7b971d32d0249c1794173d83102a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0add43764dc8132e300e1393e3335a344b8015dda18f1b6f44516ebc6dc2825b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end