class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https:www.nitrc.orgpluginsmwikiindex.phpdcm2nii:MainPage"
  url "https:github.comrordenlabdcm2niixarchiverefstagsv1.0.20241208.tar.gz"
  sha256 "adf089c6a6949e5deb90ffe0d617d2995f34231713c7bccc7e6b034935ea1a51"
  license "BSD-3-Clause"
  version_scheme 1
  head "https:github.comrordenlabdcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b26f522e3a07cbcf657930754f3faf56ee785ffbcefb2b1469260c9cf4d27b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc11fe5395146f3894047b80c51599b8b41f8e0323abdb613a86372b831b9ac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b0fa79c510fe9fb54335f310bbbb7436c3e70078637cf6c3f643ee67cbc901b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c0677847ce1857678b5d69045be0687ef75c459ed15a6a6ea0298a034e7b27e"
    sha256 cellar: :any_skip_relocation, ventura:       "076386f0e39c6cfc8d31c55750fe16061a17bfd233edaef924e3db48e652b25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e1232b9a1668c78e342eeddb9636daa2a3c5d7b1d1be1b312ce7f84956b0988"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-sample.dcm" do
      url "https:raw.githubusercontent.comdangomsample-dicommasterMR000000.dcm"
      sha256 "4efd3edd2f5eeec2f655865c7aed9bc552308eb2bc681f5dd311b480f26f3567"
    end

    resource("homebrew-sample.dcm").stage testpath
    system bin"dcm2niix", "-f", "%d_%e", "-z", "n", "-b", "y", testpath
    assert_predicate testpath"localizer_1.nii", :exist?
    assert_predicate testpath"localizer_1.json", :exist?
  end
end