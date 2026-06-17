class Rustnet < Formula
  desc "Cross-platform network monitoring terminal UI with deep packet inspection"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://ghfast.top/https://github.com/domcyrus/rustnet/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "846f89a9c6cb5a2de6b9d42cf5a8a435e343906cbe9083776ddcc7fdbbb8857b"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60b390d45e6fecd6435a0b7b4fe7f718e66ea4cef1b9c81a00059dd5d17f9cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b15eca38ca0b3c1c3cc7800f4cbd039831b0616b6e70fdca01cb3c9ca49a9a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c8324446d3068637c38b9a03526fd58f6b2ffa6b2af7663922d43321e014036"
    sha256 cellar: :any_skip_relocation, sonoma:        "61613d5a0ccb18b3914ee78aed28f6b46a1b0672f3e33e02a7cd1a6976809e3f"
    sha256 cellar: :any,                 arm64_linux:   "9408c55b36cc65b45e883f55e4b7639c7e18f3f5f836cbc1988631ccfe5864a0"
    sha256 cellar: :any,                 x86_64_linux:  "822fcca6989c718a580c3e32b98ca2afd0116604ff1ab2c9e3ceb9199a018e90"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkgconf" => :build
    depends_on "elfutils"
  end

  def install
    ENV["RUSTNET_ASSET_DIR"] = buildpath/"assets-generated"
    (buildpath/"assets-generated").mkpath

    if OS.linux?
      # Homebrew's compiler shim rewrites `clang` invocations to `gcc`, which
      # breaks libbpf-cargo's BPF compile step (it runs `clang -target bpf`,
      # an option gcc rejects). Surface the real clang from llvm in a shim
      # dir that we place first on PATH; regular C compiles still go through
      # Homebrew's gcc as intended.
      (buildpath/"bpf-clang").mkpath
      (buildpath/"bpf-clang"/"clang").make_symlink Formula["llvm"].opt_bin/"clang"
      ENV.prepend_path "PATH", buildpath/"bpf-clang"
    end

    system "cargo", "install", *std_cargo_args

    asset_dir = buildpath/"assets-generated"
    bash_completion.install asset_dir/"rustnet.bash" => "rustnet"
    zsh_completion.install asset_dir/"_rustnet"
    fish_completion.install asset_dir/"rustnet.fish"
    man1.install asset_dir/"rustnet.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustnet --version")
    assert_match "network monitoring", shell_output("#{bin}/rustnet --help").downcase

    output = shell_output("#{bin}/rustnet --log-level not-a-level 2>&1", 1)
    assert_match "Invalid log level", output
  end
end