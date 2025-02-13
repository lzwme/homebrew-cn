class Identme < Formula
  desc "Public IP address lookup"
  homepage "https:www.ident.me"
  url "https:github.compcarrierident.mearchiverefstagsv0.5.tar.gz"
  sha256 "5d33131694f62d1560fe85f4fc8546109d8cfb704ca8100b71047fe76a7aa71a"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0edc49761fdb19abb7de3fe4ff45a1dc58bb85e18c6a34c045f1a88dcbde447a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebe125e92723fd8c4a4bf8eb0c3ba3ded8e524b06968e5d802272e2278dcb5b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5e91b1ac5e7fbbbcdfabdd4c709b99c1bf9e667cd0046f82323bec3d7ae3043"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ac43e662bbdf04b80911d78c642321ceca980d81466ef7c44fc074dc4e236e"
    sha256 cellar: :any_skip_relocation, ventura:       "a60d1a76f161a617a94539a26ad6b8c5bfc51e1c966b93dc986dc1e6ab8234ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb5f44feaf79402bef01094cf190b1cc3892a22c3a56f87cdd5e25aea9ac9f9"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  def install
    system "cmake", "-S", "cli", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "ipv4", shell_output("#{bin}identme --json -4")
  end
end