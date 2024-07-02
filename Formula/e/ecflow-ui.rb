class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.13.2-Source.tar.gz"
  sha256 "948f848668455e68214acd8167a3ba581e4415e82524fc531e3e09ca257c3cd1"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "fa3d0b7071ad32765ec41d105a031b12bcf83701fd75c0c47262ba7e954d0a79"
    sha256                               arm64_ventura:  "6a2ec157c83c642b4b9244df4d041cd920f666ac349a6391e8d0d8b9a17444f0"
    sha256                               arm64_monterey: "464d9a211052ee700c9c8af2dc1bbe50f1ec164fb8fbe231472f3cba958c4916"
    sha256                               sonoma:         "165384dd99c1452812184247f1a2e4fc37508a559422d44e081132729448c896"
    sha256                               ventura:        "ecbf7c795574dce3e9ba6d1d0415c1a60884743c4107de85732d9b715fbf7352"
    sha256                               monterey:       "cbfbe0c339bfb5ac54dc1f6b5f41955f4d21da1cacdd90e97858e986a1e7af91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea4a85634ad6b67902f00385e71d30e2c1fb3726569e6698107c9f891224f73"
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

    #  check that the startup script runs
    system "#{bin}/ecflow_ui", "-h"
    help_out = shell_output("#{bin}/ecflow_ui -h")
    assert_match "ecFlowUI", help_out
    assert_match "fontsize", help_out
    assert_match "start with the specified configuration directory", help_out
  end
end