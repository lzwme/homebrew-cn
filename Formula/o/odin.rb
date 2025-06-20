class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https:odin-lang.org"
  url "https:github.comodin-langOdin.git",
      tag:      "dev-2025-06",
      revision: "cd1f66e85c22b019adf53835f5d24231cb071e6d"
  version "2025-06"
  license "BSD-3-Clause"
  head "https:github.comodin-langOdin.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sequoia: "ca3c7fda6ff4f285373e5115f269555d7d9f544764f4c024e0ff16b5836a109b"
    sha256                               arm64_sonoma:  "0f2d101296a06d88f4b914f798530dab39159ceb410ee6ed9cd1a3f0ffa8febe"
    sha256                               arm64_ventura: "02e34bdb4417933bc0f42e7e74ae19ad31fffe622bbd483af7b7095d836f12d4"
    sha256 cellar: :any,                 sonoma:        "58556f14bc0d816199f4562e8371eb4cdfc2373acf186112b3d8dc12a757c4f3"
    sha256 cellar: :any,                 ventura:       "88f066b32c13a404494da37ddb9f6a492716aa14676515b1f01f1e9316d2ac20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d1f83c10f8aa873f49a6f27cdc434f0e533a3dee755862e53ed8e0274ec1536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b3f867de9938f30e01d63fe0edf1a430c09fa8eb96c77e58405aa5b8a0b482"
  end

  depends_on "glfw"
  depends_on "lld"
  depends_on "llvm"
  depends_on "raylib"

  resource "raygui" do
    url "https:github.comraysan5rayguiarchiverefstags4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+(\.\d+)*)?$) }
    ENV.llvm_clang if OS.linux?
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