class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.13.7-Source.tar.gz"
  sha256 "658a8d31e14e625be93ad6c952ac8ef6929a23c68d79b1d670496f1860fef370"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:  "153bc8ab240d65a16a4c5ad4449c185d90329ef43ea074c6504acb0680e8a9a4"
    sha256                               arm64_ventura: "94420e9fd169676d0a1c33cbc2f47a64466195057a0047d8ec732ffd2c0c48ab"
    sha256                               sonoma:        "e9eee9af7a98101c0838eba512f52128b8fda9d97b3393115b7218f1e968604c"
    sha256                               ventura:       "7263d14acf0987506e03b09cedbe0e21ad34316f80330d110ecc719bd513497c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d02added8979e97cc532eecd8354c125016fa1e2d71dc399b39902d992d718"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  uses_from_macos "libxcrypt"

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