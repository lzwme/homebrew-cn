class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://ghfast.top/https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c3897831e86d3394f4d21a21548df8e758a64e03edad1484cf83202347f352cd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26bdb78751a5e268ece4fc1e7e121797ef0105bf9c383f3bb368484a39ef6c6c"
    sha256 cellar: :any,                 arm64_sequoia: "feb1203392626ee2ee1e562c5a4473e1fb4d47a7f4829d0193d9710111002c2c"
    sha256 cellar: :any,                 arm64_sonoma:  "0136bc5ec62c1cba6554158331ac743af6a233ec958640b4d975787810f91953"
    sha256 cellar: :any,                 sonoma:        "5e38fa8ca8ddf80562a1e6ebabbc6ec8cf911440433ffba4cfcb02023ca71a1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8722555cad6b6a5bb5e96b0e25477cd67ace73b412a51e99a85fd204ee66bc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bf08d0e331658ab63999f9c3f809bcb737bd6b7ad3e6ee17cbd697e8c48333"
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