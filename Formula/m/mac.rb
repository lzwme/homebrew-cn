class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1113_SDK.zip"
  version "11.13"
  sha256 "bbe7579ff68648400f278484484e7a04a5b79823f91c0331c360bdbc6d65567b"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dba98e290a8c1fd57e5f5ad3537572422705d1b712b19e96290ccb188eb40a4d"
    sha256 cellar: :any,                 arm64_sonoma:  "b282fd308623490dcde390bdb587e3546231e3707507459bf4d32da09efe9969"
    sha256 cellar: :any,                 arm64_ventura: "b48bf8471921754493a5ac9be1e7daba4349c70a39add01dc7c42377876ebfee"
    sha256 cellar: :any,                 sonoma:        "b48c6c26fa0eb24e2f3d3384200a5022e7e92b1f2e00aba2c00718c4960f07d4"
    sha256 cellar: :any,                 ventura:       "f004c8554e64eb75fa7d2d7e127fa8869a262d3e2ff5969d3d9bed38b833fd63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3193e508967ce8f06827554b8ff0b4b9888deb5988d81c72d08a44de5bf6a121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16792ed8307b602419c0dbc1bd899f5377710a3e1da61ee2be4d8048e49c05b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end