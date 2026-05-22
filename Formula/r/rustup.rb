class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://ghfast.top/https://github.com/rust-lang/rustup/archive/refs/tags/1.29.0.tar.gz"
  sha256 "de73d1a62f4d5409a2f6bdb1c523d8dc08aa6d9d63588db62493c19ca8f8bf55"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  compatibility_version 1
  head "https://github.com/rust-lang/rustup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "040e2eb689f99acefa1849bd9c5f7591ba100fda29323901859b7a86e68d6bf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94400995ac4847eee9753117cf8833beed89d9154304a5ea58d736e4d297b9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f977dd0fd72ed019b2c6aef6195e1052e5d09e502a846f1c65b6b49f3e5c501d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6b80251f606dee170ceb341dc13b4f890dcc24b5a7d65eeaa0e14aec1506c21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98763babc2873c4af6a48531c80314659bd8f13ce782d7ed6d427868085f7526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81179ed5f8f61f32cd181b5f278a60616a345f8b01e39949501674f0ec85e744"
  end

  keg_only "it conflicts with rust"

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "no-self-update")

    # Upstream installs this binary as `rustup-init`, but Homebrew packages
    # `rustup` directly and should not provide a separate installer entrypoint.
    mv bin/"rustup-init", bin/"rustup"

    %w[cargo cargo-clippy cargo-fmt cargo-miri clippy-driver rls rust-analyzer
       rust-gdb rust-gdbgui rust-lldb rustc rustdoc rustfmt].each do |name|
      bin.install_symlink bin/"rustup" => name
    end

    (buildpath/"settings.toml").write <<~TOML
      default_toolchain = "stable"
    TOML
    pkgetc.install "settings.toml"
    bin.env_script_all_files libexec/"bin", RUSTUP_OVERRIDE_UNIX_FALLBACK_SETTINGS: pkgetc/"settings.toml"

    generate_completions_from_executable(libexec/"bin/rustup", "completions")
  end

  def post_install
    (HOMEBREW_PREFIX/"bin").install_symlink bin/"rustup"

    # Remove the old Homebrew-created symlink during upgrades, but leave any
    # user-managed `rustup-init` file alone.
    rustup_init = HOMEBREW_PREFIX/"bin/rustup-init"
    rustup_init.unlink if rustup_init.symlink? && rustup_init.readlink.to_s.match?(%r{(?:Cellar|opt)/rustup/})
  end

  def caveats
    <<~EOS
      To use rustup, ensure you have "$(brew --prefix rustup)/bin" in your $PATH:
        #{Formatter.url("https://rust-lang.github.io/rustup/installation/already-installed-rust.html")}

      This formula does not provide `rustup-init`.
    EOS
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".rustup"
    ENV.prepend_path "PATH", bin

    assert_match "stable", shell_output("#{bin}/rustup default")
    assert_match "stable", shell_output("#{bin}/rustc --version 2>&1")

    system bin/"cargo", "new", "--bin", "./app"
    cd "app" do
      system bin/"cargo", "fmt"
      system bin/"rustc", "src/main.rs"
      assert_equal "Hello, world!", shell_output("./main").chomp
      assert_empty shell_output("#{bin}/cargo clippy")
    end

    # Check that Homebrew only exposes the packaged `rustup` entrypoint.
    refute_path_exists bin/"rustup-init"
  end
end