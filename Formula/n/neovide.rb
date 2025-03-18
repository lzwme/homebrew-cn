class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https:neovide.dev"
  url "https:github.comneovideneovidearchiverefstags0.14.1.tar.gz"
  sha256 "ca89ddd63b2a321ff0b7fb2afbaa33d125c207ed6b8663e5fb6d6f665329b899"
  license "MIT"
  revision 1
  head "https:github.comneovideneovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6fe6421436c0452f8fada6d8d27b8cdf8035bcca3369949d0573cef8cd377ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d809b5451c96327c4c574097ed0432d37307733fa816ce2ae821341be29744d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b125091a42af4296ee697e7286f692a0181aca313a05aff63206109582953a01"
    sha256 cellar: :any_skip_relocation, sonoma:        "1176698a9e5736a4b687eda38e0428d61441fd443fbf1963bd5eedf5109416b9"
    sha256 cellar: :any_skip_relocation, ventura:       "f03febcf44a281ebd18b93d6bc8b1805f9ae0adfaa3eefe49418ad22d538d90a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d615931f3e1f8c12fb29257c41e349d6fd08cf5bb701178d023986a14ae7f2d7"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "neovim"

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build, since: :catalina

  on_macos do
    depends_on "cargo-bundle" => :build
  end

  on_linux do
    depends_on "expat"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "harfbuzz"
    depends_on "icu4c@77"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    # `libxcursor` is loaded when using X11 (DISPLAY) instead of Wayland (WAYLAND_DISPLAY).
    # Once https:github.comrust-windowingwinitcommitaee95114db9c90eef6f4d895790552791cf41ab9
    # is in a `winit` release, check `lsof -p <neovide-pid>` to see if dependency can be removed
    depends_on "libxcursor"
    depends_on "libxkbcommon" # dynamically loaded by xkbcommon-dl
    depends_on "mesa" # dynamically loaded by glutin
    depends_on "zlib"
  end

  fails_with :gcc do
    cause "Skia build uses clang target option"
  end

  def install
    ENV["FORCE_SKIA_BUILD"] = "1" # avoid pre-built `skia`

    # FIXME: On macOS, `skia-bindings` crate only allows building `skia` with bundled libraries
    if OS.linux?
      ENV["SKIA_USE_SYSTEM_LIBRARIES"] = "1"
      ENV["CLANG_PATH"] = which(ENV.cc) # force bindgen to use superenv clang to find brew libraries

      # GN doesn't use CFLAGS so pass extra paths using superenv
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", Formula["freetype"].opt_include"freetype2"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", Formula["harfbuzz"].opt_include"harfbuzz"
    end

    system "cargo", "install", *std_cargo_args

    return unless OS.mac?

    # https:github.comburtonageocargo-bundleissues118
    with_env(TERM: "xterm") { system "cargo", "bundle", "--release" }
    prefix.install "targetreleasebundleosxNeovide.app"
    bin.write_exec_script prefix"Neovide.appContentsMacOSneovide"
  end

  test do
    test_server = "localhost:#{free_port}"
    nvim_cmd = ["nvim", "--headless", "--listen", test_server]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 10

    neovide_cmd = [bin"neovide", "--no-fork", "--remote-tcp=#{test_server}"]
    ohai neovide_cmd.join(" ")
    neovide_pid = spawn(*neovide_cmd)

    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end