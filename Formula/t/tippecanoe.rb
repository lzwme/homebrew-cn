class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.41.0.tar.gz"
  sha256 "2a48da51a0603e8e766f798b9365e3e946bfde266efd975f553a22e84214e9f4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73e3c6d1974125b2973f8bdfb42707ac6b02faa16fbb253c1f705401442c3f1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba754257ee627cffc5ee08f7e5e29140d4bf49808a87b37b0c3dbb8ce50d021e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af163f525831965637545c7cf16b627e37d362046ab1f1d9e8c076922c4bef96"
    sha256 cellar: :any_skip_relocation, sonoma:         "81d1d0cd3f09bcf23f1816ddf56f0fa43cf15834af5fb4cbe2777f22dd2386a5"
    sha256 cellar: :any_skip_relocation, ventura:        "d74d7d0743b00a06604634a14b270b59a1d9358f1ee45b69f0c2216f986fa317"
    sha256 cellar: :any_skip_relocation, monterey:       "946ab8f7ef16eec8053fcde06c0d972a7d1366cf7df74e1071ef124ea2fd8e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "561c432496d411042b8f689d0426d572b17ef51ac6c244989b6efd8dfba0fdc9"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end