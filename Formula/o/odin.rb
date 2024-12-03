class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https:odin-lang.org"
  url "https:github.comodin-langOdin.git",
      tag:      "dev-2024-11",
      revision: "e6475fec4d2a3e34099b24a7a3bf890c7a3ef8d9"
  version "2024-11"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comodin-langOdin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "31e940b62db1b555df91381d21b8c435774f6438239e47e124fcec7004cfc63e"
    sha256 cellar: :any,                 arm64_sonoma:  "189fe3a399760b5a44c5e42ccb57d07fb6d79d1516051cc6e69bb430b0d72f74"
    sha256 cellar: :any,                 arm64_ventura: "548a349c0147afa70db136b3a5df3210ae48dbaf3473e5ef9a4bef26f1726dab"
    sha256 cellar: :any,                 sonoma:        "25f2095090821214a1ec0e8c61d6dd8c0d78ce74cfd6d483aa2a70f6ede4c51c"
    sha256 cellar: :any,                 ventura:       "ccd82ddf333eb27e715e62857646177129cc9a5a3ff0c9847d70ca8499f07272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11fc24e935cbf3e3828f9cb55ba45f8cf0a96ee7c1898be962e616474ec580b4"
  end

  depends_on "glfw"
  depends_on "llvm@18"
  depends_on "raylib"

  resource "raygui" do
    url "https:github.comraysan5rayguiarchiverefstags4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+(\.\d+)*)?$) }
    ENV["LLVM_CONFIG"] = (llvm.opt_bin"llvm-config").to_s

    # Delete pre-compiled binaries which brew does not allow.
    buildpath.glob("vendor***.{lib,dll,a,dylib,so,so.*}").map(&:unlink)

    cd buildpath"vendorminiaudiosrc" do
      system "make"
    end

    cd buildpath"vendorstbsrc" do
      system "make", "unix"
    end

    cd buildpath"vendorcgltfsrc" do
      system "make", "unix"
    end

    raylib_installpath = if OS.linux?
      "vendorrayliblinux"
    elsif Hardware::CPU.intel?
      "vendorraylibmacos"
    else
      "vendorraylibmacos-arm64"
    end

    glfw_installpath = if OS.linux?
      "vendorglfwlib"
    else
      "vendorglfwlibdarwin"
    end

    ln_s Formula["glfw"].lib"libglfw3.a", buildpathglfw_installpath"libglfw3.a"

    ln_s Formula["raylib"].lib"libraylib.a", buildpathraylib_installpath"libraylib.a"
    # In order to match the version 500 used in odin
    ln_s Formula["raylib"].libshared_library("libraylib", "5.5.0"),
      buildpathraylib_installpathshared_library("libraylib", "500")

    resource("raygui").stage do
      cp "srcraygui.h", "srcraygui.c"

      # build static library
      system ENV.cc, "-c", "-o", "raygui.o", "srcraygui.c",
        "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{Formula["raylib"].include}"
      system "ar", "-rcs", "libraygui.a", "raygui.o"
      cp "libraygui.a", buildpathraylib_installpath

      # build shared library
      args = [
        "-o", shared_library("libraygui"),
        "srcraygui.c",
        "-shared",
        "-fpic",
        "-DRAYGUI_IMPLEMENTATION",
        "-lm", "-lpthread", "-ldl",
        "-I#{Formula["raylib"].include}",
        "-L#{Formula["raylib"].lib}",
        "-lraylib"
      ]

      args += ["-framework", "OpenGL"] if OS.mac?
      system ENV.cc, *args
      cp shared_library("libraygui"), buildpathraylib_installpath
    end

    # By default the build runs an example program, we don't want to run it during install.
    # This would fail when gcc is used because Odin can be build with gcc,
    # but programs linked by Odin need clang specifically.
    inreplace "build_odin.sh", ^\s*run_demo\s*$, ""

    # Keep version number consistent and reproducible for tagged releases.
    args = []
    args << "ODIN_VERSION=dev-#{version}" unless build.head?
    system "make", "release", *args
    libexec.install "odin", "core", "shared", "base", "vendor"
    (bin"odin").write <<~EOS
      #!binbash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}odin" "$@"
    EOS
    pkgshare.install "examples"
  end

  test do
    (testpath"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system bin"odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output(".hellope")

    (testpath"miniaudio.odin").write <<~EOS
      package main

      import "core:fmt"
      import "vendor:miniaudio"

      main :: proc() {
        ver := miniaudio.version_string()
        assert(len(ver) > 0)
        fmt.println(ver)
      }
    EOS
    system bin"odin", "run", "miniaudio.odin", "-file"

    (testpath"raylib.odin").write <<~EOS
      package main

      import rl "vendor:raylib"

      main :: proc() {
         raygui.
        assert(!rl.GuiIsLocked())

         raylib.
        num := rl.GetRandomValue(42, 1337)
        assert(42 <= num && num <= 1337)
      }
    EOS
    system bin"odin", "run", "raylib.odin", "-file"

    if OS.mac?
      system bin"odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"
    end

    (testpath"glfw.odin").write <<~EOS
      package main

      import "core:fmt"
      import "vendor:glfw"

      main :: proc() {
        fmt.println(glfw.GetVersion())
      }
    EOS
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["glfw"].lib if OS.linux?
    system bin"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=true",
      "-extra-linker-flags:\"-L#{Formula["glfw"].lib}\""
    system bin"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=false"
  end
end