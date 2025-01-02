class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https:github.comneovideneovide"
  url "https:github.comneovideneovidearchiverefstags0.13.3.tar.gz"
  sha256 "21c8eaa53cf3290d2b1405c8cb2cde5f39bc14ef597b328e76f1789b0ef3539a"
  license "MIT"
  head "https:github.comneovideneovide.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a707205c55f9f4b08ce1228baf5de9c7e3501c55dd161c45c647f362ddc9164e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca6b4e3e0b753cbb25ce6c1c8cc83baa3e8dddfbae1bb3b8cb03102c6ad8c60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe99aabf60388de8d103fde859c56193b2c7192ef2282b99249baf1a7bae8b68"
    sha256 cellar: :any_skip_relocation, sonoma:        "6175015a4a4ca06f7b9d948a733b4ad85580837d6f12e587f8e2742fde3981cc"
    sha256 cellar: :any_skip_relocation, ventura:       "b89ecae1aae8bfdd70cf0b966b14091fe088a1eaf7fcdacced64a89ccbefb111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e119675832daa71d45d9cc1a805d14c014caf8f5f45744c6ccd57231e3ff91cd"
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
    depends_on "python@3.12" => :build # https:github.comrust-skiarust-skiaissues1049
    depends_on "expat"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "harfbuzz"
    depends_on "icu4c@76"
    depends_on "jpeg-turbo"
    depends_on "libpng"
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
      if build.stable?
        skia_bindings_version = Version.new(File.read("Cargo.lock")[name = "skia-bindings"\nversion = "(.*)", 1])
        odie "Remove `python@3.12` dependency and PATH modification" if skia_bindings_version >= "0.80.0"
        ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec"bin"
      end

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