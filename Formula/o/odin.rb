class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https:odin-lang.org"
  url "https:github.comodin-langOdin.git",
      tag:      "dev-2025-03",
      revision: "951bef4ade595e5fa7e8f0d0681e4e34ab1ca9d3"
  version "2025-03"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comodin-langOdin.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "2a2d7ff1769de89b3459b0656f91ef2edac0c32ff2284bc65bf93ef2d4a083f5"
    sha256                               arm64_sonoma:  "efb819ad6918b4717e6d56000cecde79295f6194425a04dd8ee0ae4b9fa7087e"
    sha256                               arm64_ventura: "05d9dddb2358edd6e993b0db3ea56470311add688c34205fd3085cc173e19b4c"
    sha256 cellar: :any,                 sonoma:        "4dbaf32374bf44f73a9548a1a2775d63d136e7352b74b9534d8c66a0be6183fe"
    sha256 cellar: :any,                 ventura:       "317a185fa4c620660fcb00a10940ca2c31ea717b17b385c73d9dfb80c151f152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "471253dad0370f3f48e9054cc676003dd6bbf7ce7c42c5c75b7fc80561a46dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56fac6a248c55d3b523220a6dedb43673a5285bd7ebf1c6bc13a38c62fe0d99d"
  end

  depends_on "glfw"
  depends_on "llvm@19"
  depends_on "raylib"

  resource "raygui" do
    url "https:github.comraysan5rayguiarchiverefstags4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+(\.\d+)*)?$) }
    ENV["LLVM_CONFIG"] = (llvm.opt_bin"llvm-config").to_s
    ENV.append "LDFLAGS", "-Wl,-rpath,#{llvm.opt_lib}" if OS.linux?

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
    else
      "vendorraylibmacos"
    end

    raygui_installpath = if OS.linux?
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
      buildpathraylib_installpathshared_library("libraylib", "550")

    resource("raygui").stage do
      cp "srcraygui.h", "srcraygui.c"

      # build static library
      system ENV.cc, "-c", "-o", "raygui.o", "srcraygui.c",
        "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{Formula["raylib"].include}"
      system "ar", "-rcs", "libraygui.a", "raygui.o"
      cp "libraygui.a", buildpathraygui_installpath

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
      cp shared_library("libraygui"), buildpathraygui_installpath
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
    (bin"odin").write <<~BASH
      #!binbash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}odin" "$@"
    BASH
    pkgshare.install "examples"
  end

  test do
    (testpath"hellope.odin").write <<~ODIN
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    ODIN
    system bin"odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output(".hellope")

    (testpath"miniaudio.odin").write <<~ODIN
      package main

      import "core:fmt"
      import "vendor:miniaudio"

      main :: proc() {
        ver := miniaudio.version_string()
        assert(len(ver) > 0)
        fmt.println(ver)
      }
    ODIN
    system bin"odin", "run", "miniaudio.odin", "-file"

    (testpath"raylib.odin").write <<~ODIN
      package main

      import rl "vendor:raylib"

      main :: proc() {
         raygui.
        assert(!rl.GuiIsLocked())

         raylib.
        num := rl.GetRandomValue(42, 1337)
        assert(42 <= num && num <= 1337)
      }
    ODIN
    system bin"odin", "run", "raylib.odin", "-file"

    if OS.mac?
      system bin"odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"
    end

    (testpath"glfw.odin").write <<~ODIN
      package main

      import "core:fmt"
      import "vendor:glfw"

      main :: proc() {
        fmt.println(glfw.GetVersion())
      }
    ODIN
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["glfw"].lib if OS.linux?
    system bin"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=true",
      "-extra-linker-flags:\"-L#{Formula["glfw"].lib}\""
    system bin"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=false"
  end
end