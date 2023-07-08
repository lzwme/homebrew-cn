class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.11.1-Source.tar.gz"
  sha256 "c9d4273a5723bc9baec2b4cd4a3dc4daeced7d7b14c2ea899876861ad8708e28"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "87941fe0d6bae6d2e15edba889114301c30f03f5d0df5986d072a17f4385c487"
    sha256                               arm64_monterey: "c4c9ff8806038b34c08b304daab4a6ba20fde2f7538d805711defc74eab524fc"
    sha256                               arm64_big_sur:  "09c4249f97616899e31b90c127b0e9886eb7a324e56e9fe6c792d56c552ed5e8"
    sha256                               ventura:        "cb254f690ed41f15c6092826b3a94d964d09acc6040ec088880342a7f4c68c43"
    sha256                               monterey:       "d4583471e2d8f2eaa320b8cf1f588e916afb78e35a9881106c4b5247a8a844f7"
    sha256                               big_sur:        "e4ece7ea68b52f2f3aa1544a9a3b0435efd8ac3daf0177073d892775b582dc61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcabd58826dfcf34852ec542bf7e8a9765bc86b9806f02d6ee6b5d5dfd0ff5af"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  # requires C++17 compiler to build with Qt
  fails_with gcc: "5"

  # Fixes a typo in upstream's code. Remove once merged and released.
  # PR ref: https://github.com/ecmwf/ecflow/pull/35
  patch do
    url "https://github.com/ecmwf/ecflow/commit/5bf5f8490f3ba0a39c9119ba03f8a9b349f6c3ec.patch?full_index=1"
    sha256 "747e7d8bfb84e3e60c7775a58607bdbf666d83b9c3cc544dc79bbf9ff3e2922b"
  end

  def install
    mkdir "build" do
      system "cmake", "..",
                      "-DENABLE_SSL=1",
                      "-DENABLE_PYTHON=OFF",
                      "-DECBUILD_LOG_LEVEL=DEBUG",
                      "-DENABLE_SERVER=OFF",
                      *std_cmake_args
      system "make", "install"
    end
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