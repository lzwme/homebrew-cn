class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://ghfast.top/https://github.com/symless/synergy/archive/refs/tags/v1.20.3.tar.gz"
  sha256 "a64cbed157160c332f8569c406bfb33b556da282456bf1c7f41738b2e26e398d"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  head "https://github.com/symless/synergy.git", branch: "master"

  # This repository contains old 2.0.0 tags, one of which uses a stable tag
  # format (`v2.0.0-stable`), despite being marked as "pre-release" on GitHub.
  # The `GithubLatest` strategy is used to avoid these old tags without having
  # to worry about missing a new 2.0.0 version in the future.
  livecheck do
    url :stable
    regex(/[^"' >]*?v?(\d+(?:\.\d+)+)[^"' >]*?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc5ff76e3391fe8fe6a44f7be77cb8cad26cb9f784d9fc86779fe5602c9c9659"
    sha256 cellar: :any, arm64_sequoia: "d2c581d293fde0b9bf9eeac58d0ae1e5ca2f199bc65d74c6d9fc58e9c38b2c96"
    sha256 cellar: :any, arm64_sonoma:  "601f8380ab33f700974514e10d97665e16fd557219ef447e97b7daba0251bfa8"
    sha256 cellar: :any, sonoma:        "a3b6614da5c342202567d2a864b97ecb3f3f63f85a634d0ba72a4b090ab624fa"
    sha256 cellar: :any, arm64_linux:   "504e88c9573fe20ce24da98ebae3523097e66b93d41a327e0aa23999192b00d4"
    sha256 cellar: :any, x86_64_linux:  "0fbc93d0da72112b86ac70b6c17e34caf2cbb9b75057bcd88f1c3e7a63fbc561"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1402
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "libnotify"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "libxtst"
  end

  fails_with :clang do
    build 1402
    cause "needs `std::ranges::find`"
  end

  resource "synergy-extra" do
    url "https://github.com/symless/synergy-extra.git",
        revision: "d7195c502ce317924f03d6258d56852fc2575a2c"

    # Version.cmake in `synergy-extra` reads .git folder of `synergy`.
    # but it's submodule uses ssh protocol which will be failed in CI
    # and so we use tarball of `synergy` and apply patch to ignore git process
    patch :DATA
  end

  def install
    # Avoid statically linking OpenSSL on macOS
    inreplace "cmake/Libraries.cmake", "set(OPENSSL_USE_STATIC_LIBS TRUE)", ""

    mkdir_p buildpath/"ext/synergy-extra"
    (buildpath/"ext/synergy-extra").install resource("synergy-extra")

    if OS.mac?
      # Disable macdeployqt to prevent copying dylibs.
      inreplace "src/gui/CMakeLists.txt",
                /"execute_process\(COMMAND \${MACDEPLOYQT_CMD}.*\)"/,
                '"MESSAGE (\\"Skipping macdeployqt in Homebrew\\")"'
    end

    args = %w[
      -DBUILD_TESTS:BOOL=OFF
      -DSYNERGY_VERSION_RELEASE=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install buildpath/"build/bundle"
      bin.install_symlink prefix/"bundle/Synergy.app/Contents/MacOS/synergy" # main GUI program
      bin.install_symlink prefix/"bundle/Synergy.app/Contents/MacOS/synergy-server" # server
      bin.install_symlink prefix/"bundle/Synergy.app/Contents/MacOS/synergy-client" # client
    end
  end

  service do
    run [opt_bin/"synergy"]
    run_type :immediate
  end

  def caveats
    # The binaries built by brew are not signed by a trusted certificate, so the
    # user may need to revoke all permissions for 'Accessibility' and re-grant
    # them when upgrading synergy-core.
    on_macos do
      s = <<~EOS
        Synergy requires the 'Accessibility' permission.
        You can grant this permission by navigating to:
          System Preferences -> Security & Privacy -> Privacy -> Accessibility

        If Synergy still doesn't work, try clearing the 'Accessibility' list:
          sudo tccutil reset Accessibility
        You can then grant the 'Accessibility' permission again.
        You may need to clear this list each time you upgrade synergy-core.
      EOS
      # On ARM, macOS is even more picky when dealing with applications not signed
      # by a trusted certificate, and, for whatever reason, both the app bundle and
      # the actual executable binary need to be granted the permission by the user.
      # (On Intel macOS, only the app bundle needs to be granted the permission.)
      #
      # This is particularly unfortunate because the operating system will prompt
      # the user to grant the permission to the app bundle, but will *not* prompt
      # the user to grant the permission to the executable binary, even though the
      # application will not actually work without doing both. Hence, this caveat
      # message is important.
      on_arm do
        s += "\n" + <<~EOS
          On ARM macOS machines, the 'Accessibility' permission must be granted to
          both of the following two items:
            (1) #{opt_prefix}/bundle/Synergy.app
            (2) #{opt_bin}/synergy
        EOS
      end
      s
    end
  end

  test do
    version_string = version.major_minor_patch.to_s
    assert_match(/synergy-server v#{version_string}.*, protocol v/,
                 shell_output("#{opt_bin}/synergy-server --version"))
    assert_match(/synergy-client v#{version_string}.*, protocol v/,
                 shell_output("#{opt_bin}/synergy-client --version"))

    assert_match "synergy-server: failed to load config",
                 shell_output("#{opt_bin}/synergy-server 2>&1", 4)
    assert_match "synergy-client: a server address or name is required",
                 shell_output("#{opt_bin}/synergy-client 2>&1", 3)
  end
end

__END__
diff --git a/cmake/Version.cmake b/cmake/Version.cmake
index 0ea44d0..392f6a0 100644
--- a/cmake/Version.cmake
+++ b/cmake/Version.cmake
@@ -51,36 +51,6 @@ function(version_from_git_tags VERSION VERSION_MAJOR VERSION_MINOR VERSION_PATCH
   set(minor_match "${CMAKE_MATCH_2}")
   set(patch_match "${CMAKE_MATCH_3}")
 
-  set(git_path "${CMAKE_CURRENT_SOURCE_DIR}/.git")
-  if(NOT EXISTS ${git_path})
-    message(FATAL_ERROR "Not a Git repository: ${git_path}")
-  endif()
-  
-  find_package(Git)
-  if(NOT GIT_FOUND)
-    message(FATAL_ERROR "Git not found")
-  endif()
-  message(VERBOSE "Git repo: " ${CMAKE_CURRENT_SOURCE_DIR})
-
-  # Creating a release tag through the GitHub UI creates a lightweight tag, so use --tags
-  # to include lightweight tags in the search.
-  execute_process(
-    COMMAND ${GIT_EXECUTABLE} describe origin/master --tags --long --match "v[0-9]*"
-    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
-    OUTPUT_VARIABLE git_describe
-    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
-  )
-  if (NOT git_describe)
-    message(FATAL_ERROR "No version tags found in the Git repository")
-  endif()
-  message(VERBOSE "Git describe: " ${git_describe})
-
-  string(REGEX REPLACE ".*-([0-9]+)-g.*" "\\1" rev_count ${git_describe})
-  if ("${rev_count}" STREQUAL "")
-    message(FATAL_ERROR "No revision count found in Git describe output")
-  endif()
-  message(VERBOSE "Changes since last tag: " ${rev_count})
-
   if (SYNERGY_VERSION_RELEASE)
     
     message(VERBOSE "Version is release")