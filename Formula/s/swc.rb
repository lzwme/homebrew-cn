class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.12.11.tar.gz"
  sha256 "31b95eb4dd4870d644455571ba58ee3de3391ea5c3f7eac631e71a1660b031c7"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e4f136366035fdb240ffd5b7223947db530b75d6f9aaf1f1e25ec6d4898577c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c80d6ddcbd2abb82ae39f295d9d158ce91854b735dba38cf88c820982bee19db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7908f6767ee2a7729b9dbaef88c6cb3b784e8bebf0b526719f11196d7f8673b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c30832291c78e80a2db23799c50124f94bee10310d14e7135bf726609f73207"
    sha256 cellar: :any_skip_relocation, ventura:       "3028515a9d28e500f5ffe2925897092e16202bd4d7e4c12fd20c38026132ffbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e147b702535b5734e92b59f933d9d3412c2a07e555eb994aba159d3b541113e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ded1518335445639c07f8c0e4e87e9c9bb8f6f7b159928a9b15398f73163fc9f"
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

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end