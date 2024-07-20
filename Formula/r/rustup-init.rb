class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https:github.comrust-langrustup"
  url "https:github.comrust-langrustuparchiverefstags1.27.1.tar.gz"
  sha256 "f5ba37f2ba68efec101198dca1585e6e7dd7640ca9c526441b729a79062d3b77"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comrust-langrustup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "013f6c53bb2e86339ce87aa9b0037c3f4b8f90b284f7ffe5cd6c61c40009fb11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "108787dd49e54c94323548f4d1e734d014d2393b1a2d4f2809ed45a25c7e2287"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af73b45b59e043cb9289bb3b542dae84f2a971d688a140e61c5946f3242cecb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c02a888a58c2d3814b4fbca069002155321fdb1e3de895e96eb99721fced270"
    sha256 cellar: :any_skip_relocation, ventura:        "8785b4a6132a59a3d9db5fa5c0c5e723d3113ffc5e1e1069de961b8b5072a2f7"
    sha256 cellar: :any_skip_relocation, monterey:       "70883eb56cf51f9bf8eca13d79b3a86e2621a197c3a5ebdaf20e8721d1d34eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24da7814d4e6496bb1edca5baf93e52150a163065ab4cf24c826846252e26208"
  end

  keg_only "it conflicts with rust"

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=no-self-update", *std_cargo_args

    %w[cargo cargo-clippy cargo-fmt cargo-miri clippy-driver rls rust-analyzer
       rust-gdb rust-gdbgui rust-lldb rustc rustdoc rustfmt rustup].each do |name|
      bin.install_symlink bin"rustup-init" => name
    end
    generate_completions_from_executable(bin"rustup", "completions", base_name: "rustup")
  end

  def post_install
    (HOMEBREW_PREFIX"bin").install_symlink bin"rustup", bin"rustup-init"
  end

  def caveats
    <<~EOS
      To initialize `rustup`, set a default toolchain:
        rustup default stable
    EOS
  end

  test do
    ENV["CARGO_HOME"] = testpath".cargo"
    ENV["RUSTUP_HOME"] = testpath".rustup"
    ENV.prepend_path "PATH", bin

    assert_match "no default is configured", shell_output("#{bin}rustc --version 2>&1", 1)
    system bin"rustup", "default", "stable"

    system bin"cargo", "init", "--bin"
    system bin"cargo", "fmt"
    system bin"rustc", "srcmain.rs"
    assert_equal "Hello, world!", shell_output(".main").chomp
    assert_empty shell_output("#{bin}cargo clippy")

    # Check for stale symlinks
    system bin"rustup-init", "-y"
    bins = bin.glob("*").to_set(&:basename).delete(Pathname("rustup-init"))
    expected = testpath.glob(".cargobin*").to_set(&:basename)
    assert (extra = bins - expected).empty?, "Symlinks need to be removed: #{extra.join(",")}"
    assert (missing = expected - bins).empty?, "Symlinks need to be added: #{missing.join(",")}"
  end
end