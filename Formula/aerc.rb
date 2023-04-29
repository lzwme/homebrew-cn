class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.15.1.tar.gz"
  sha256 "55cd54e45634d684590658ffc14c047cdf7366bbdf163d0445e2f093474ddef5"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_ventura:  "72c43a9aaf4dd9d22d59656cab9f1b68e735c3e039980f6646bd4403390cc32c"
    sha256 arm64_monterey: "e53d7b0e9fc11110f73ba1ed27a4e424bbb646b4527cf8ad12bdaf5f2e157c5d"
    sha256 arm64_big_sur:  "c984f01d7d59b148d5160e2b9ff2578ff32c41e4f7f4899b0f2af26ad53a471b"
    sha256 ventura:        "b421219a32438d68f15f3953f7d9ee32c43d21aeb7a4bf3f1f20eeaf07fc1ae1"
    sha256 monterey:       "e9942ca3997067543efa03f6e00332f206ff2da3e0ae7ef34cb06f8be102411c"
    sha256 big_sur:        "2fad37b9d4b5e8881c3bc74dfa65e8301a9d25776cb0e8532cfd369713fcce5f"
    sha256 x86_64_linux:   "58e815ed64a50d92e09c499383a3ad331409c7a276e688c5f446b3e6b6decaff"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end