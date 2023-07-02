class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://ghproxy.com/https://github.com/solidiquis/erdtree/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "eb35415059cc28d4cedd450214eeb8b4d37e4165d10f69af0261df9c5ffe3029"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bd7cc2a5d23f010b9b7ee369ea108eee80a56716eae2b38c06df5c449a28e19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4098b47d69fac2631c0f39ceadcfb287bd738469698f60996b93d1427e91988f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b82b1d5e6768a9fd1c20b24e7ae88fbe72a9ce6db87e61609dfd04440477145e"
    sha256 cellar: :any_skip_relocation, ventura:        "645d88e437cab97da99b44002349d88cb60d0eb258db74d8048ebbaff3da636d"
    sha256 cellar: :any_skip_relocation, monterey:       "e772631a3cc19e52ae3e75f50debf779fc6cee9402e47f90a0532d2fa570d061"
    sha256 cellar: :any_skip_relocation, big_sur:        "351d179b2e5a9c334dcc3bf1406e0ca4d5e9950fb448281e535a904546ccf641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a637ac09328d36648a729f7cb109c2ae4bd519e4cddf4557f852127fd737aae8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"erd", "--completions")
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/erd")
  end
end