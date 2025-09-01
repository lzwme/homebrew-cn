class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.34.tar.gz"
  sha256 "7e33164d01c7eca4c0dc531a06134a0f67369cb922861a15db9c823f915d392a"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f80c54b5509b290733971aaf13ec7a6099c1e39791998f71e43f1e0757f87ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4099ef53f2c8a0fbfb90e066f9aae7e7a74a01377e1d0f8a258420f8d629c29b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d992048bf035f6eedb02e4720c86b8ea4b729a922f6c14560cb8b3c82215a4fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "60583e171ffced609a5ad18252203c9d02301b5984c921d5f5c1669a98947894"
    sha256 cellar: :any_skip_relocation, ventura:       "d1c6b29036fde8cd74bd933d9b2314987bc59f920de1a79fea7da23e792a28cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658266a8e8f3cc4376034ec17d4f618db945d26a5cffe149bb5c750050c5c2e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end