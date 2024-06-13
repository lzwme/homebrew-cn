class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https:editorconfig.org"
  url "https:github.comeditorconfigeditorconfig-core-carchiverefstagsv0.12.8.tar.gz"
  sha256 "508f7633416a2ce3c05104ea7daac61c4953803c9935cca6e059086cfa67ee63"
  license "BSD-2-Clause"
  head "https:github.comeditorconfigeditorconfig-core-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3c964060e34e20aca1c15b8e9d57fc27d6f38dd0d180df128d0cacfca7aaf45"
    sha256 cellar: :any,                 arm64_ventura:  "11e65b8174b934c672cf6209e0b9be8d60c8e8e60bc7f2a1db98310092157453"
    sha256 cellar: :any,                 arm64_monterey: "f3ee92ff41f995cd6405dfeb73a452630cd1ea6ab41d4f3395cd9b375a8cf6f4"
    sha256 cellar: :any,                 sonoma:         "8c9d93e8e80e134144fd441661165a69c09aabdfd94769290198e4a05b6e1468"
    sha256 cellar: :any,                 ventura:        "dd014a8d3674569e7071f7c1eda0c153a579ce71e92f49d15198acb684c39706"
    sha256 cellar: :any,                 monterey:       "19ce8f99802e4fc54a3824771ce35048f8586031f1ff1917c6c8a429148f24d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca6d27f7806279e58053485815bc1171563cf8a161c3bbd3927f037732274f42"
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}editorconfig", "--version"
  end
end