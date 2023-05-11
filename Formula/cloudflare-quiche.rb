class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.17.2",
      revision: "a4ac85642eca40e45cc6e0cfd916d55b81537e2c"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "632625d47e0824558f969a5ca0da6635f4b4b56e7d8546851af5d9b95ead677b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5281e4d45af803981b70facced601d4639c2d9c08eba142a144727de3a6f05b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5a091ee67a71612e4f912a374429f60b81d5e1026cd85da9fcfd0c46b6bb771"
    sha256 cellar: :any_skip_relocation, ventura:        "a00ec74631f9fcdc79b698934cfe5c20248c2d334bad454c035540f3664c181a"
    sha256 cellar: :any_skip_relocation, monterey:       "992b3645c98a80f4692f06bf2f49eee968b84e1f413f0d622fd4ea1e4a89c969"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a440558d290b95096faf5ba589dab9056809e4ec0592b33877b6833c1dacf90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10c1095971d8fbbc2e2bafd083d5fdca5d5cef19d75b0165b8b838a3b8090c26"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
  end
end