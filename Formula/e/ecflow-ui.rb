class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.13.5-Source.tar.gz"
  sha256 "f09e19534a14ae3746be301914c726ae51fe2d52ffc595d34d23fa845bd00ac3"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:  "c6e5abfd5aab56b67276e21535a37b833ca1f7bc8286196bdb8c707090e34edd"
    sha256                               arm64_ventura: "ec18cd2397b8b6cb6cc7c8928af6f91a98777c05f472995db3187377e4136965"
    sha256                               sonoma:        "c7a798dd5ff7f5b438347d19ace2a19d93f08971d38d2e47b3e437c1124a12c2"
    sha256                               ventura:       "dd7d4f5f256c9b18ac81029933f90fee86b3045d8db995cd2cc0bdfdf4dc8cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c592c4983963f0197663d46351f76c514ca2f4329ee092563db276e27394204"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  uses_from_macos "libxcrypt"

  # requires C++17 compiler to build with Qt
  fails_with gcc: "5"

  def install
    args = %w[
      -DECBUILD_LOG_LEVEL=DEBUG
      -DENABLE_PYTHON=OFF
      -DENABLE_SERVER=OFF
      -DENABLE_SSL=1
      -DENABLE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # current tests assume the existence of ecflow_client, but we may not always supply
  # this in future versions, but for now it's the best test we can do to make sure things
  # are linked properly
  test do
    # check that the binary runs and that it can read its config and picks up the
    # correct version number from it
    binary_version_out = shell_output("#{bin}/ecflow_ui.x --version")
    assert_match @version.to_s, binary_version_out

    help_out = shell_output("#{bin}/ecflow_ui -h")
    assert_match "ecFlowUI", help_out
    assert_match "fontsize", help_out
    assert_match "start with the specified configuration directory", help_out
  end
end