class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/0.40.0.tar.gz"
  sha256 "ae341107103c0f7fe022a6f8c2b790e89e1784c09ab15c7e5b2aaa93627c816d"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "126215f41727a46ed32d46bc3e82dd775da53b66d450e068a6524bae8e7c71ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b636a8913a7dadf34c94d47e8bd8e9605ea63ce01b671ec76063748c0f92029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68c564835f8409235800d30d09a242289ed5498fdda9e1aebe67967de7388ff4"
    sha256 cellar: :any_skip_relocation, ventura:        "5740a3f51481c348e5c6c09e6577feda0cb73b88c6794fcc6c28d79f6efe6914"
    sha256 cellar: :any_skip_relocation, monterey:       "8b9c78153c3f9774d94abb8425237ebb8c47fc10be40f8482b87bff710b87dca"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cc18be713254ff71660158c6381507558e207e8fbbe72be8c4b25190b3d76ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6453f583e80ab8a1b5e34e22f1dc509015e51a4a6f46e9560cd0450d9bbc810d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end