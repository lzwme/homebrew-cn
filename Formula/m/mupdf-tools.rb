class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.7-source.tar.gz"
  sha256 "35a54933f400e89667a089a425f1c65cd69d462394fed9c0679e7c52efbaa568"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3c378663f7f186bd07bab94f1d96c32bda4d09e41cc99b2576b4ab45000840b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f4555cc4d71cdaf228bd2529695e7a84d6ad28a24e7c0df6ff27d31fdb4d55f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90342e03136a2ad2ad5e455c65851c3b8f7c3ec6abc5e3eddaedcf8d3025993e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6c8d01e5cc8b1a79d732ffeb5dd6f05191f6bead1288d9963841ecc263d92e8"
    sha256 cellar: :any_skip_relocation, ventura:        "ed8fc6315fb27be2819a79e09128cb915b654d20aa59409a7828b4a520208316"
    sha256 cellar: :any_skip_relocation, monterey:       "ddb299307dfc8871a8e5290c79e937df3ae5888f2cf3f07b5aefe18552168f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bc7f97489bcb8a94dfd9c691874d1be597e8a036907c94e1a7c4269768ca041"
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