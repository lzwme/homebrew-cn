class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "67658e873e2b06238b63ea8b3786266ce5ec9a221816a3bb72fb29749f89e0eb"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efd931b6e8ad70808bcb216be6df12a6399ba5ac038489b3bf255fb9acfd9e09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33d24e64613eb93b33060ead371f612bb92bfacf26bd22be0f9f1b96032eaeb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce70872615a30b9c0ce77ef0507298b9ae0c19ab0c0c7b6dea55aaa8a947f790"
    sha256 cellar: :any,                 arm64_linux:   "57a2da16c5045cb6fd335faf76a2ae321f3ed59b84d7dc04e970d91160d86291"
    sha256 cellar: :any,                 x86_64_linux:  "a78c249e3517e0ba78f4d64e8485d88b9ecfc2b8c39d4b64db10974a947d8314"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")
  end
end