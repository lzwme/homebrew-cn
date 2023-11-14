class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.5-source.tar.gz"
  sha256 "6e5679cdfaaef9c7e89e296395220ce2c133ed3dcad51a478667336c6eaec706"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae622cac05fee066d89947a6a889876eeae2aba18330269c03fe53a14bd9670e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80b27382bf1ef3966e68ccfb8eb04913e83d50fa213d8c20323989d73b98c089"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70aa88328cf0e85b0f9fb7fda3fbff273006043010d12f3b19a84f884ed762b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fc49b3ae2d28cd66b967c6c73cae65705de60d910a567f3f17627f111ac3d68"
    sha256 cellar: :any_skip_relocation, ventura:        "747409d713e69aebf2b0d463a0e72289485fba0ee7a5f885c7b737b012b3dab7"
    sha256 cellar: :any_skip_relocation, monterey:       "7896a60ad7f2e468cb7710bfa909498986f131a26e73421fa27e864d5de6b698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9049b22ae57d4964824c8a0cc884d617dbd2c5ddc6547c7f53e397891929142a"
  end

  conflicts_with "mupdf",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end