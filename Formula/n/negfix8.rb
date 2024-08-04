class Negfix8 < Formula
  desc "Turn scanned negative images into positives"
  homepage "https:web.archive.orgweb20220926032510https:sites.google.comsitenegfix"
  url "https:web.archive.orgweb20201022025021https:sites.google.comsitenegfixdownloadsnegfix8.3.tgz"
  sha256 "2f360b0dd16ca986fbaebf5873ee55044cae591546b573bb17797cbf569515bd"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8cfaf079531e850a4938db52d6a99d4626142eba30165284a39d9349d805a18b"
  end

  # https:github.comchrishuntnegfix8pull2#issuecomment-1956815369
  deprecate! date: "2024-06-10", because: :unmaintained

  depends_on "imagemagick"

  def install
    bin.install "negfix8"
  end

  test do
    (testpath".negfix8frameprofile").write "1 1 1 1 1 1 1"
    system bin"negfix8", "-u", "frameprofile", test_fixtures("test.tiff"),
        "#{testpath}output.tiff"
    assert_predicate testpath"output.tiff", :exist?
  end
end