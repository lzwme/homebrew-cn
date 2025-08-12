class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.50.1.tar.gz"
  sha256 "85197a9469fe479fc278e77e87ede6eeb55b7d42d0a530e8b828f3ab9b213358"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd7146c2cde7fbbc6c8142e0c0dd0c49c213768680eb9e3c880a6b8e15f26986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5afe18b96e387c8afa696986fc6a20be2435d6d3def3949a68ba715b020bf790"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6209244235b7e3a12a9fe53a99304a2f6d58f29fcacf7dba9d4dd9dbcb3b2f6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "12264de2d4b2c20291d5a5a939eb2d9f505b7d69b0a498d6153c7e4ad8c264a9"
    sha256 cellar: :any_skip_relocation, ventura:       "bd837c6523344c0caff6cfa63ea0ebe5975b4ffee64da87fc055701d76c779c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6547791dadfacd099f607176000efcf495e39bf70865f9888e155ac7a25501c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8db93cceb6781cd300ec02be77a42b117c43af9d93e2fed17d74fdde9156bc0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  # update deps, upstream pr ref, https://github.com/dprint/dprint/pull/1003
  patch do
    url "https://github.com/dprint/dprint/commit/bb6ddc6034f73adb188fb2c40aa34d0c6a7ec6de.patch?full_index=1"
    sha256 "ea54bc0c12dbd3057a0c95d4c922fd35459f338112c14eb8dc4fe96eb742a733"
  end

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
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
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end