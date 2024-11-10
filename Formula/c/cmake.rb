class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.31.0cmake-3.31.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.31.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.31.0.tar.gz"
  sha256 "300b71db6d69dcc1ab7c5aae61cbc1aa2778a3e00cbd918bc720203e311468c3"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34fe6c7f83913b147faf3970db99213d1197f64a2bb411b45b4020e80e004dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d10dcc360253726cc3872666f2ea7bc830bfb4dc25d73c79e28b4458973e301f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1500ca2cb91a2b56708c8b0ec6825edde8cc1afbdeaede2f7fca18c2ca42db3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dc996c171867e69a7daa690e2101f983a56a9bc010a699775606d6c9a731ebb"
    sha256 cellar: :any_skip_relocation, ventura:       "51c2b535f266689edfcc5bb4e595c09544ea4221deaeed559c63a26f73d1df26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "556d7c78c3c297098e13889ecaa603bd786bfdc43fc748ec900b02454360219c"
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