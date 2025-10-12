class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://ghfast.top/https://github.com/EttusResearch/uhd/archive/refs/tags/v4.9.0.0.tar.gz"
  sha256 "c2288998dc0eeece287934e016d1501d5c200aa8047553d7405f3c3e0e5edac8"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "3085e0b5f7f06a02d2d87463fdde8dfcfaa0c759b59390642f266eb57ecd4341"
    sha256                               arm64_sequoia: "f9c4f3d415a8ba15cb24dcda5658fa12e187daf9326917c2a45307968ff421ea"
    sha256                               arm64_sonoma:  "01b70f03d78f980439ba453ce3bc0563445c53be8ce37fd30b2fa0ad3af1f9a9"
    sha256                               sonoma:        "7efa662510ab15847e9906037a9dfdee4ed169f673324636375b215113661741"
    sha256                               arm64_linux:   "7ec118566c3e56e68d47bb7f59ec2467e52f12a6b0f2781533d0defdeda4c168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c7600beea0f32580f1176451a7b34489b5ae9061950e73dc40819e26c581303"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.14"

  on_linux do
    depends_on "ncurses"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  # Workaround for Boost 1.89.0 until fixed upstream.
  # Issue ref: https://github.com/EttusResearch/uhd/issues/869
  patch :DATA

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    args = %W[
      -DENABLE_TESTS=OFF
      -DUHD_VERSION=#{version}
    ]
    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
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