class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/software/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.11.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.11.tar.xz"
  sha256 "a73ef05fe37dd585f7d87068e4a0639760419f810138bd75c61ddaa1f9e2131e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f12d9a3cd558d8436462332026942c1b9adf6020da22b16d920944562fb55f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47b8019f3e69a3b80f5e0f257e75e2de36bf3d46110f0bb19896f72eb19443a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0250a559a1f74c1b3388e6e4a752fe926a78bcca3c7fc1d227901771ecc418d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "53258fbd2a6ac91d30ae8c2a760809343f2bb4232327ccce55b7f72cdaeb280a"
    sha256 cellar: :any_skip_relocation, ventura:       "f94e6f0882e439442090df7db04245090b686820d120f48d9320d9969dbe570c"
    sha256                               arm64_linux:   "9637630568940e1968685d5bc8783d316b96cb28add6edcc60cce6139c812078"
    sha256                               x86_64_linux:  "55c8ed62c1fba4614ef9e8700aae3bb506e6a0f0a5e41728ec54eb6802e390ac"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end