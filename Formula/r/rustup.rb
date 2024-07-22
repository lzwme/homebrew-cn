class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https:github.comrust-langrustup"
  url "https:github.comrust-langrustuparchiverefstags1.27.1.tar.gz"
  sha256 "f5ba37f2ba68efec101198dca1585e6e7dd7640ca9c526441b729a79062d3b77"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comrust-langrustup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "560483ea618feb0ab45e6ba6cd53e28dddf8cc3d0c409baaec3fbd8e2e69e3ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dadf8e846a2601466f2b6975f2f73622c3c18f7c3e48e91b046ea40495c7a8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcde370fff27a1b49dc2945a372c7e6e42913b47c5f6c5de80a3bf28f2590146"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d3ff694ccc56d65c43334301c3bc9a772923cd3e0adee3c09be656ff66ff167"
    sha256 cellar: :any_skip_relocation, ventura:        "149c5498411875a4bbaee5c1bf93c3db3f4352cbcdf9c0ea4044648d62f306eb"
    sha256 cellar: :any_skip_relocation, monterey:       "8039f9b672acbdaa7ff0bf985992fcd96c054a392b53e65c44cc2e10b919c36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "380ff9d1495472783139dd5ab76cb416a01b99423f550e215b75a02592a07451"
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