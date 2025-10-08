class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.15.0-Source.tar.gz"
  sha256 "326ea7dbe436f9435c51616fc3e611f69efc55ae0e0e32c4ded25cfefe9b05fd"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "deb4c2c11e82bd398037d8a7b44d4ebdb595051f4e1e1d734f955c885a8405f2"
    sha256 arm64_sequoia: "ccbbe9ce0c49795d58fce1c62349fd4926f7a3f710a47bb75d9570d25b3693f1"
    sha256 arm64_sonoma:  "3bcbed2f33d556792621927de123e00c1faadb6d3eb941c416a66bbd49e1e5b8"
    sha256 sonoma:        "9c2c81eda98ca123f8fcb01839a5391c629cb9b165ba9807ba669f21d2b95acb"
    sha256 x86_64_linux:  "606c52f77bcfc7e3f6eca5551e93f23a206edb70c95ad216f17fb504f8f19f32"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtcharts"
  depends_on "qtsvg"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  # Replace boost::asio::deadline_timer since it was removed in Boost 1.89.0
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/ecmwf/ecflow/57ef9c0a48d6651a9cf5ceedf4e73b555eed23bf/releng/brew/patches/5.15.0.patch"
    sha256 "87c53a3cc96a36a00589ff0ea3bc44b62e56dd4539fda81155d72b5cf84db2a3"
  end

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