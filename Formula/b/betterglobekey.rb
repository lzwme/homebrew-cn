class Betterglobekey < Formula
  desc "Reworked Globe key for faster input source switching"
  homepage "https://github.com/Serpentiel/betterglobekey"
  url "https://ghfast.top/https://github.com/Serpentiel/betterglobekey/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "0d71ebae2d27312fca9000739ee9d15230ee9f6d5f14de84c563e9335e01d34a"
  license "MIT"
  head "https://github.com/Serpentiel/betterglobekey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2da2c56921f8f0dcadc50d10126963f4d3124afb5d2b411a85303fd61986de72"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "12513a25ad6ced112e4e9920b468b12b04978c2beb58bc3fec21f019a9a29229"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae9796a303fa9146e3fadadac633ff86e8e4dfef8147c22f81586bf9875947dc"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"betterglobekey", "completion")
  end

  service do
    run opt_bin/"betterglobekey"
    keep_alive true
    log_path var/"log/betterglobekey.log"
    error_log_path var/"log/betterglobekey.log"
  end

  test do
    list = shell_output("#{bin}/betterglobekey list")
    assert_match(/^com\.apple\.keylayout\./, list)
  end
end