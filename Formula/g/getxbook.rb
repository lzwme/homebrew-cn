class Getxbook < Formula
  desc "Tools to download ebooks from various sources"
  homepage "https://njw.name/getxbook/"
  url "https://njw.name/getxbook/getxbook-1.3.tar.xz"
  sha256 "a1b8252a50ba61e7c66a82161af35e08f4e6187e8c2cea1e2a040d167932de18"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?getxbook[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6bb08299390cc6bd1e82ebf4c3bfe9b15711645c9cb09525fb4ed70d1d7fbc5f"
    sha256 cellar: :any, arm64_tahoe:       "1cd590d9e843093b1425cf52f0635ecec0552c84792ebcb16b4436962f8decfc"
    sha256 cellar: :any, arm64_sequoia:     "27280fe2e0ded386f16ed1c0e0807cae3afd0ad0929ef40952dc5f6d305a98b4"
    sha256 cellar: :any, arm64_linux:       "10a6317fe73e22e88465b3b0405bacc30c6b20c614ae58eb177ccc7406a1b047"
    sha256 cellar: :any, x86_64_linux:      "f7bba65c19614b08f1836c012d9d64a71caae129ad475a9132ad1d2147ffb117"
  end

  depends_on "openssl@3"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    bin.install "getgbook", "getabook", "getbnbook"
  end

  test do
    assert_match "getgbook #{version}", shell_output("#{bin}/getgbook", 1)
  end
end