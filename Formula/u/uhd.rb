class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://ghfast.top/https://github.com/EttusResearch/uhd/archive/refs/tags/v4.8.0.0.tar.gz"
  sha256 "a2159491949477dca67f5a9b05f5a80d8c2b32e91b95dd7fac8ddd3893e36d09"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 2
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "4ab65a47300d350348cf8847f2538a99910a716bad25372ea0ec88dad514f066"
    sha256                               arm64_sonoma:  "2518c54f6faa4d564f7575088ba7741e7451116af4048efddb53a033c2551190"
    sha256                               arm64_ventura: "2feabcf1402e03fdb6c8065502e98cf642b3d904233380c441c5f41323dec13d"
    sha256                               sonoma:        "2efb778054b5a4ad2938a45473aebbc098f0ac8170bf6f92bdb7b6bc74173971"
    sha256                               ventura:       "1a9a39c44ca1d5571bfd90a0f9792f48363571af0c3734e10a50b9dfc01459fc"
    sha256                               arm64_linux:   "5d0a9b89b3cc9b85fb39a5380289de4864e95feba7088282257e0fb78a0dc2f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ada9d40e0939903444936b0d0b0d3884a9cabbbc55c9ad471bf542413b2a0800"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.13"

  on_linux do
    depends_on "ncurses"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5f/d9/8518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9/mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  # Support building with CMake 4.0, pr ref: https://github.com/EttusResearch/uhd/pull/849
  patch do
    url "https://github.com/EttusResearch/uhd/commit/8caa8e1d1adb6f73a30676f42c2c80041ccc4e9a.patch?full_index=1"
    sha256 "818dd3e65c7c25040887850713fa9bf9a3f6cf3ef791b1f73f7b8de12921452f"
  end

  # Support building with Boost 1.88.0, pr ref: https://github.com/EttusResearch/uhd/pull/850
  patch do
    url "https://github.com/EttusResearch/uhd/commit/16dbcb37976ca1e959d275f20246924fb455176e.patch?full_index=1"
    sha256 "0dc5cf491ca2037819e894fdb21b8b98230eb8ca2aee0d2312889e365da961e8"
  end

  # Workaround for Boost 1.89.0 until fixed upstream.
  # Issue ref: https://github.com/EttusResearch/uhd/issues/869
  patch :DATA

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    system "cmake", "-S", "host", "-B", "build",
                    "-DENABLE_TESTS=OFF",
                    "-DUHD_VERSION=#{version}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end

__END__
diff --git a/host/CMakeLists.txt b/host/CMakeLists.txt
index 746a977bd..815c2a2c8 100644
--- a/host/CMakeLists.txt
+++ b/host/CMakeLists.txt
@@ -306,7 +306,6 @@ set(UHD_BOOST_REQUIRED_COMPONENTS
     date_time
     filesystem
     program_options
-    system
     serialization
     thread
     unit_test_framework
diff --git a/host/uhd.pc.in b/host/uhd.pc.in
index 4a5f67c96..e1a8115a9 100644
--- a/host/uhd.pc.in
+++ b/host/uhd.pc.in
@@ -11,5 +11,5 @@ Requires:
 Requires.private: @UHD_PC_REQUIRES@
 Conflicts:
 Cflags: -I${includedir} @UHD_PC_CFLAGS@
-Libs: -L${libdir} -luhd -lboost_system
+Libs: -L${libdir} -luhd
 Libs.private: @UHD_PC_LIBS@