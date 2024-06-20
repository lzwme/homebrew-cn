class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.13.0-Source.tar.gz"
  sha256 "a14f4e97cc9123bc6cadfb3ecbf3899e27b6deb53058590bba7a4dae12f3e029"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "23593c3cb8d9c4207a76e36352b85ebd9500a400378bc040fdaf59229ca6101b"
    sha256                               arm64_ventura:  "a116c960755b8e4c5227ded668a4d22643e4bd96cb0f83017cf1993927d55214"
    sha256                               arm64_monterey: "89c63734991933932884ec212b19a28d64b110f46258bbc59f7ee077111ec55c"
    sha256                               sonoma:         "49385e41229201774a32dc7b560286ffe9a289f6774c70d88cfd100b44f6f035"
    sha256                               ventura:        "f2dd444a665d6d6f6c9a5c24cef2dbf10a6a1ca84411a77a58286612f846db39"
    sha256                               monterey:       "8bdf3dd54132804f31344d4517be9ec96f2bf13d9c8f9e1bc272d21cffe2c0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "549461677c05ea62e14b8098913a6a789625ce7f42714645c65978fe37ff1ceb"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

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