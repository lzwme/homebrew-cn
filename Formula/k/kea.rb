class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  url "https://ftp.isc.org/isc/kea/3.0.1/kea-3.0.1.tar.xz"
  mirror "https://dl.cloudsmith.io/public/isc/kea-3-0/raw/versions/3.0.1/kea-3.0.1.tar.xz"
  sha256 "ec84fec4bb7f6b9d15a82e755a571e9348eb4d6fbc62bb3f6f1296cd7a24c566"
  license "MPL-2.0"
  head "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

  # NOTE: the livecheck block is a best guess at excluding development versions.
  #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.

  livecheck do
    url "ftp://ftp.isc.org/isc/kea/"
    # Match the final component lazily to avoid matching versions like `1.9.10` as `9.10`.
    regex(/v?(\d+\.\d*[02468](?:\.\d+)+?)$/i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "323beca90e393ab4e91e0332d76bc8e0f0fd4a85a468db91568e5b539deaba68"
    sha256 arm64_sequoia: "a15fca159a6fd13ce68587bfe1311eeebd7cfc3a17b0912d67b84274071d59b4"
    sha256 arm64_sonoma:  "b0db3ea982ee59af69e2516fc272c50db8ddc0c8f3a116d049a4adf48fee8f7c"
    sha256 sonoma:        "bcb189cc1a301a567c25fd5d65de726193e5473966634f29aff1816f34daced4"
    sha256 arm64_linux:   "a841d1efe727ca9e8f4aef24f07d738c56abbfcfcf8cde0d5e4c34d19345e1ee"
    sha256 x86_64_linux:  "61725eefe9578f25d98019a6ccba4fc09ab4e0a78f690477cee56db581cda2db"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  # Workaround for boost >= 1.89
  # https://gitlab.isc.org/isc-projects/kea/-/issues/4085
  patch :DATA

  def install
    # TODO: We probably also need to `inreplace` the following so they don't install in the prefix:
    #   - LOCALSTATEDIR_INSTALLED
    #   - RUNSTATEDIR_INSTALLED
    #   - SYSCONFDIR_INSTALLED
    # Report this upstream so they're not forced to be inside the `prefix`.
    inreplace "meson.build" do |s|
      # the build system looks for `sudo` to run some commands, but we don't want to use it
      s.gsub! "SUDO = find_program('sudo', required: false)",
              "SUDO = find_program('', required: false)"
    end

    system "meson", "setup", "build", "-Dcpp_std=c++20", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Remove the meson-info directory as it contains shim references
    rm_r(pkgshare/"meson-info")
  end

  test do
    system sbin/"keactrl", "status"
  end
end

__END__
diff --git a/meson.build b/meson.build
index cedc949773..aed020ebb2 100644
--- a/meson.build
+++ b/meson.build
@@ -189,7 +189,10 @@ message(f'Detected system "@SYSTEM@".')
 
 #### Dependencies
 
-boost_dep = dependency('boost', version: '>=1.66', modules: ['system'])
+boost_dep = dependency('boost', version: '>=1.69', required: false)
+if not boost_dep.found()
+    boost_dep = dependency('boost', version: '>=1.66', modules: ['system'])
+endif
 dl_dep = dependency('dl')
 threads_dep = dependency('threads')
 add_project_dependencies(boost_dep, dl_dep, threads_dep, language: ['cpp'])
diff --git a/src/lib/asiolink/asio_wrapper.h b/src/lib/asiolink/asio_wrapper.h
index a33c56f2d4..e1ae6e06f6 100644
--- a/src/lib/asiolink/asio_wrapper.h
+++ b/src/lib/asiolink/asio_wrapper.h
@@ -74,9 +74,11 @@
 #pragma GCC push_options
 #pragma GCC optimize ("O0")
 #include <boost/asio.hpp>
+#include <boost/asio/deadline_timer.hpp>
 #pragma GCC pop_options
 #else
 #include <boost/asio.hpp>
+#include <boost/asio/deadline_timer.hpp>
 #endif
 
 #endif // ASIO_WRAPPER_H