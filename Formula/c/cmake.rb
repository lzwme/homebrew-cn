class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.31.3cmake-3.31.3.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.31.3.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.31.3.tar.gz"
  sha256 "fac45bc6d410b49b3113ab866074888d6c9e9dc81a141874446eb239ac38cb87"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89891f8bcbec3470764bd7d0460773d354b04f9331baaab97ba0fe2ae86e5036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b6ac3e359b4e5e2534c9ab556c218ae4744fc00e9121fca7e5f91abe48f3689"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d3c917fec6e56e93b0eaad41f59887615efb4d4418234cc4170c2972977e4c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a8069852f7a0940680ca7834de9818fd661e6eeea1389054eb1b831b913025c"
    sha256 cellar: :any_skip_relocation, ventura:       "b7a3f9483c6163bf47bab7f1cf44f19a908e6649afc426ed730763afdce34505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2b0e8d31bf157218a9a119675b26cc2d559d4bd7c2806f3904e689b5406d523"
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