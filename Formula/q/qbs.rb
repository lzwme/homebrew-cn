class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.1.0/qbs-src-3.1.0.tar.gz"
  sha256 "0fe497e72174bcd94aba4173c36f034ae7d1b3c4f38ed39e1fe4bee2e6929f75"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only"] },
    { any_of: ["LGPL-3.0-only", "LGPL-2.1-only" => { with: "Qt-LGPL-exception-1.1" }] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
  ]
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6654e37bfa8068e5b8f0d9de2168438736e0bee98cf4b5c5cf7bdc7fa3c59507"
    sha256 cellar: :any,                 arm64_sequoia: "c5e5fb99b337335c18f46d8721b0e82ab97cd74351c4025feb075eab2727f09d"
    sha256 cellar: :any,                 arm64_sonoma:  "e2c235f11a830f1967151e7f32424f0c006d9c12e2ddf7259bf2669a5e565018"
    sha256 cellar: :any,                 sonoma:        "60d8ab7fac172ea142e1afc746d435735054893df4f61aab574c2fddd22a34bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36e8b8723bbd9f347e6f41afdfb41de3b3c658c8860e843ba41f9adbbf3f1b48"
  end

  depends_on "cmake" => :build
  depends_on "qt5compat"
  depends_on "qtbase"

  def install
    args = %w[
      -DQBS_ENABLE_RPATH=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C

    (testpath/"test.qbs").write <<~QBS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    QBS

    system bin/"qbs", "run", "-f", "test.qbs"
  end
end