class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "90392dbe4bac664558425e1e51c1e4dc421d6ca124756c28d989786f89056a26"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2dad3250ce7750ae153d5ee2b5c9aea23b6395dbab53fb4b702db53a3725b8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc05d4c656b445cba12bdc8a15cb9f21bbc2301c616817c4c595edaf72a2646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80f762073de55a20ca213b4c6a353a59a0b438ef8885dbc11c49911bc7326d37"
    sha256 cellar: :any_skip_relocation, sonoma:        "05eb8d4f9de87c0fe2424bd9cdd0a99437d8b0abf0153ec73285527ffe75fb0d"
    sha256 cellar: :any,                 arm64_linux:   "b2b9bad6bdda372f43a540cc3eca88e5e664cbd3b32a45661d58e94b5392a354"
    sha256 cellar: :any,                 x86_64_linux:  "4160726c0d40813004c043af268e94d41bc3a694d0819176871c1979543f3ec8"
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