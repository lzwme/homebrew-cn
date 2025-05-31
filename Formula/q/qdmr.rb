class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https:dm3mat.darc.deqdmr"
  url "https:github.comhmatuschekqdmrarchiverefstagsv0.12.2.tar.gz"
  sha256 "4be8692e7270ac51032f43d56227ddee7ba7b515e98f8f3f867398899593e779"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "6ab16e6c0e074af48e283646dfe8fec3e4c43bd75a72c3d61e70c6aaaf7d52e1"
    sha256 arm64_sonoma:  "9f328b9c8835430065a0b2fb6732b8af7bceb89f54fecc9e3069353327e00a04"
    sha256 arm64_ventura: "1921e4934527288d3e837706cb5a53b74c46a89881f53ba09f8bb430a78577c2"
    sha256 sonoma:        "9e07686e7cebb8ea130a9d1183541f3d8396e5fc0bd171e090317430e086e53f"
    sha256 ventura:       "b47be9e66eed4887eadb16d6a0a1dd16a1f57943bf370342b06c1aef100a70fc"
    sha256 x86_64_linux:  "7715c1833cdd017122b29d8966de514e21a908df7f77112feea00319a769ace2"
  end

  depends_on "cmake" => :build
  depends_on "libusb"
  depends_on "qt@5"
  depends_on "yaml-cpp"

  def install
    args = %w[
      -DINSTALL_UDEV_RULES=OFF
    ]
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" # Cmake 4 workaround
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"config.yaml").write <<~YAML
      radioIDs:
        - dmr: {id: id1, name: DM3MAT, number: 2621370}

      channels:
        - dmr:
            id: ch1
            name: "Test Channel"
            rxFrequency: 123.456780   # <- Up to 10Hz precision
            txFrequency: 1234.567890

    YAML
    system bin"dmrconf", "--radio=d878uv2", "encode", "config.yaml", "config.dfu"
  end
end