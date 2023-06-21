class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://ghproxy.com/https://github.com/rustwasm/wasm-pack/archive/v0.12.0.tar.gz"
  sha256 "684a2fb39691c8231b05e5c9fb0cacf6155f0617e0458cae0cd1b5ec2d8f9600"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a49ac293759477f0a875c3fcb0d418ea6961435ee5845abca0351497acd59a99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c70d994f95515eb6591199245b791074cc7e2cf00983106641cb6c6d49621a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1df17a8fef666ad905dc65e7965388327ecec1e84db93df3fb9cfafcff350ad6"
    sha256 cellar: :any_skip_relocation, ventura:        "6a17136e39a7a6cb438bda049fe6aee026aea3646df521fb5901c9e5a30bc9b0"
    sha256 cellar: :any_skip_relocation, monterey:       "bbeaa29e32da6a91061278190334601c6ef3e92b6409cad3326fffbe72ee0092"
    sha256 cellar: :any_skip_relocation, big_sur:        "96e461e590bdc0ace284a05e10f36fb32cf28c320be258698caea8bd8659c7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a61fffe16bc2051496ff35de6656532a8d8a79c2b95f5ead5e164a34a1e67cef"
  end

  depends_on "rust" => :build
  depends_on "rustup-init"

  # Restore `--version` command, remove in next release
  patch do
    url "https://github.com/rustwasm/wasm-pack/commit/91870e497d7212db40fc4ff5453233fc3fa5546d.patch?full_index=1"
    sha256 "148006151e4fe202287b278d1269bef8ebcf30bdc7c946027cdf25e26c72bfe1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_predicate testpath/"hello-wasm/pkg/hello_wasm_bg.wasm", :exist?
  end
end