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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1adfcf92959af43b31eb55007ec19dccb0236b9e44804025aeda84f931d7a427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39caad94c4db4d5bc3ca121a7dfcdc41281281088b36b11afb24a92de653b5c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00e1f91ea9c03796a1808726abe397935567903a8dbcd22e2f3db3c9ee0d2bbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "282513938fc4e7cbb73d1c29ec969295b021cf725036b571f701bee2b25f38f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e9c1c73a958abd26ba816d34fa017e762cf048db5a9664ba0a6e404c44f5320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff7c94142160615a5919c3c673b36c62093bd19290e053f3b4738ebda500665"
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
    [:zsh, :bash].each do |shell|
      generate_completions_from_executable(
        libexec/"bin/rustup", "completions", shell.to_s, "cargo", shells: [shell], base_name: "cargo",
        shell_parameter_format: :none
      )
    end
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