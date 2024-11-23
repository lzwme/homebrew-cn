class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.31.1cmake-3.31.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.31.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.31.1.tar.gz"
  sha256 "c4fc2a9bd0cd5f899ccb2fb81ec422e175090bc0de5d90e906dd453b53065719"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https:cmake.orgdownload"
    regex(href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c50ea55135f1fd6c58900cab723418aef1dfcca2e8307b459978ba437c1256a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1e5d394cfe35d716d36f51b50bed3a0320fbf97a206dafeda92af09a65beac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "388811eceeb7e9ed4c5c1c343af5e471ff5904a5082048f9c28d0744bec61543"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f0f2104d0271e6d7d10a816746c5eddd6df5408f5b33f9e8cc7a7cd070cd60"
    sha256 cellar: :any_skip_relocation, ventura:       "ecb13b012cb924d5f7dfcf5f223d014db323642e4fec2ec9967c066824ca9306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9120cf711be3a8e03ef011a0eae29c5e3150c27dbad1cd5ea53590405738fe1b"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # Prevent the formula from breaking on versionrevision bumps.
  # Check if possible to remove in 3.32.0
  # https:gitlab.kitware.comcmakecmake-merge_requests9978
  patch :DATA

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=sharecmake
      --docdir=sharedoccmake
      --mandir=shareman
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system ".bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath"CMakeLists.txt").write("find_package(Ruby)")
    system bin"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc"html"
    refute_path_exists man
  end
end

__END__
diff --git aSourcecmSystemTools.cxx bSourcecmSystemTools.cxx
index 5ad0439c..161257cf 100644
--- aSourcecmSystemTools.cxx
+++ bSourcecmSystemTools.cxx
@@ -2551,7 +2551,7 @@ void cmSystemTools::FindCMakeResources(const char* argv0)
     _NSGetExecutablePath(exe_path, &exe_path_size);
   }
   exe_dir =
-    cmSystemTools::GetFilenamePath(cmSystemTools::GetRealPath(exe_path));
+    cmSystemTools::GetFilenamePath(exe_path);
   if (exe_path != exe_path_local) {
     free(exe_path);
   }
@@ -2572,7 +2572,6 @@ void cmSystemTools::FindCMakeResources(const char* argv0)
   std::string exe;
   if (cmSystemTools::FindProgramPath(argv0, exe, errorMsg)) {
      remove symlinks
-    exe = cmSystemTools::GetRealPath(exe);
     exe_dir = cmSystemTools::GetFilenamePath(exe);
   } else {
      ???