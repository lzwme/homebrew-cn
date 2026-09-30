class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.16.12.tar.gz"
  sha256 "a658b38c63d266bf85ce0512cf007d46ef444865a195305df5582ab014639c5a"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89a5c7b4c2643db698512ce706409271fbc1b55384815c8c580d3a6ed10a7385"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce9739522b18bf6a9a71ddb6b8557b49f092e997cfdecad7724b577575890718"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f639211644083527f23a55cacfe2df60243873033f3d65b8b5fbd69a708f33cb"
    sha256 cellar: :any,                 arm64_linux:       "e59eef03725f846991bd3c3770c185a98a96355fdbaa806f9d690fb40448ef23"
    sha256 cellar: :any,                 x86_64_linux:      "96c3cca810b96241481314a9f1f8ccb82676b12a707531d43a72abeb947e9905"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 134)
    assert_match "Lint command is not yet implemented", output
  end
end