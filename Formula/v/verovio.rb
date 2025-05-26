class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https:www.verovio.org"
  url "https:github.comrism-digitalverovioarchiverefstagsversion-5.3.0.tar.gz"
  sha256 "c36ddb2539c68b91b7a84b48e8f22ab799da1fb3dcd2d51dbd999cdef328e10d"
  license "LGPL-3.0-only"
  head "https:github.comrism-digitalverovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "bc99eac69c7af00f571908105f59054457e9374afe4d43a080fc76c65d3497e0"
    sha256 arm64_sonoma:  "5a30ec7a5380f7bd6e1ee52f01dd0f74ee50113268ecd2a2241a1a58f0453ce5"
    sha256 arm64_ventura: "58e4fc6d7a49ecbb9405d64c75e8cd126aaa5de5633216c4fedc86e40b9e22a4"
    sha256 sonoma:        "8174b7819255a731654309ee2a9a6f8eef69cbf8e6a178aaa934a2ba412be071"
    sha256 ventura:       "4b73e27a79da6cfc1137e3cb437842b3e0b3eb2232449014a02160c25b21763d"
    sha256 arm64_linux:   "a43db72aa1c0fda6af68651e3795bbd48cf9d036d5b2d5a6255eb6791a391608"
    sha256 x86_64_linux:  "4ac653b669b56c6b56df948df0870e2fe7c29af4f8edb587df7bf4c23eaddafd"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    resource "homebrew-testdata" do
      url "https:www.verovio.orgexamplesdownloadsAhle_Jesu_meines_Herzens_Freud.mei"
      sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
    end

    system bin"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}output.svg")
    end
    assert_path_exists testpath"output.svg"
  end
end