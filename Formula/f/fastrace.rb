class Fastrace < Formula
  desc "Dependency-free traceroute implementation in pure C"
  homepage "https://davidesantangelo.github.io/fastrace/"
  url "https://ghfast.top/https://github.com/davidesantangelo/fastrace/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b40aadb9c3b5114972abe26241d847cbffec99c3d0f69ea77d94ba53825ac407"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56fc3735c58874001d7ae7b8b7343f01b2c09dd5ee31f12b19b2424ac22d640d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf373613873adfac25ce751dfc66b7b9d02d1846726dacaea717450392c0a29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "224601ff11b7f419ea501ba141b40b0e586c2ba3fe932c8af1e3ee8054f5b0e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "814098109ae2ef0d91d8cc7512ebd7641f956715a87d2d58b0f8b4834dde1545"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d8a34d3b360e4413c58aaf3e3b457c0671455a754b5b63b233a2fd243769c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d710b232c6ebcdef308bdb75c6181e2807c206adb4a609abd94cc2424d9e8443"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastrace -V")

    assert_match "Error creating ICMP socket", shell_output("#{bin}/fastrace brew.sh 2>&1", 1)
  end
end