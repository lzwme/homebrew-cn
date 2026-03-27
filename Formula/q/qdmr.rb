class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://ghfast.top/https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "26f808352edaf3ad3fbba86b4d45e8e085c9d27e7cb2b78eaf548a4c763382bc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c6160045a19e7b2515227379587deb10368b64ca90c3f1103f267c2104bf3b8"
    sha256 cellar: :any,                 arm64_sequoia: "ce8540450dd832f0b634e5a257106fab0064ba3dd997662717d3f465a39d17e6"
    sha256 cellar: :any,                 arm64_sonoma:  "6ce52cad9b7d702fe5d7d08e29f8418bd8bfb9ba4f5c8cf9430d78462461be01"
    sha256 cellar: :any,                 sonoma:        "e344c3818d279f9a31bb060ce204fa1f938bea33f736361f6af0d0259e09fbc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06e4da3589fce5c735c673a4d084c1e3fa7b4d217b2f0127ec0b18debba95b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be4a1758a9c7e63bc60b33c622a626f434d4358ed8eae0681558a3146da435e"
  end

  depends_on "cmake" => :build
  depends_on "librsvg"
  depends_on "libusb"
  depends_on "qtbase"
  depends_on "qtpositioning"
  depends_on "qtserialport"
  depends_on "qttools"
  depends_on "yaml-cpp"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DINSTALL_UDEV_RULES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"config.yaml").write <<~YAML
      radioIDs:
        - dmr: {id: id1, name: DM3MAT, number: 2621370}

      channels:
        - dmr:
            id: ch1
            name: "Test Channel"
            rxFrequency: 123.456780   # <- Up to 10Hz precision
            txFrequency: 1234.567890

    YAML
    system bin/"dmrconf", "--radio=d878uv2", "encode", "config.yaml", "config.dfu"
  end
end