class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://ghproxy.com/https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.4.26.tar.gz"
  sha256 "c5784c0d2d99af46f773027d9ac25ac51ca0188bba995d167df576750fbadef6"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "accc8bf8a3589e94d0975935c50e8003a12bc61feacf7f3a28164d205b0a96fc"
    sha256 cellar: :any,                 arm64_ventura:  "babd329495ec2d0055def94b8a7753ebef111623ff3dbf0265e85aa32743d9d6"
    sha256 cellar: :any,                 arm64_monterey: "601a0e28d461a45931c9782efb7536171935e5a6617313ce8d928abcc954a810"
    sha256 cellar: :any,                 sonoma:         "07b93e212a90b05a26e57693b3446ac92b0bf7d442ac5dc4f6a7cabd0d00a7de"
    sha256 cellar: :any,                 ventura:        "4900f39b911ae21b311ec765931550c55cacf291154dac0c9933592f1a079759"
    sha256 cellar: :any,                 monterey:       "47315fdc922bbac363d96dcdd3ad9a57b7cf07d81b7a13c4ae8f523799b80ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d72dd6d12ceb9f4ae5eb8b2ca8b6e2d49a5a93a7d19ffba33908297a09abfda"
  end

  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end