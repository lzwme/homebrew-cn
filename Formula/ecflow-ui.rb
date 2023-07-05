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
    sha256                               arm64_ventura:  "353b32f0a4123aa6bc18f5f2cd1d5db8454560ea855f0363b78a987a354f0442"
    sha256                               arm64_monterey: "9149d674a1ab84bf597683873d3831f6eadb0ef544fafd8a407843747ed37675"
    sha256                               arm64_big_sur:  "cb3c6062bda1d122b752c7b1a2152c7a1307d321ad8ed85b91370c74a0ded3a2"
    sha256                               ventura:        "c8942df0ea1181b02f824872ee62393272e7311e9cde4b4ff41295fd8db6a06e"
    sha256                               monterey:       "320866e9b3d0773123deb3f0ffefe2a2d367d09388f2b9cb60a6def5c26626c2"
    sha256                               big_sur:        "08f8b866c2312fddf75b848ec30a6f7e426bd0095a8464126efee8e63b988715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "870d17542833092b5364c6d3303eb1e685fce800e26efb5a1c7adfc432af60ba"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  # requires C++17 compiler to build with Qt
  fails_with gcc: "5"

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
    assert_match "start with the specified configuraton directory", help_out
  end
end