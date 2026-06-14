class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.96.0.tar.gz"
  sha256 "5c55d3a09d39885ad9f85a98277cc7be6151229b6c3a65e169422b9a3c1e2d41"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b697ebd5085ff413e19d9992099f86bba4ffc9d144f084292a1bfec19f96d1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f8661bf11466b7595a6a7d797ad54fd0422b44e107aec0c720ffc37aa7bab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dd61b9d09ad4fdde01703d8cde4c68bb7bf15b7520cffee09e68d10d9b06765"
    sha256 cellar: :any_skip_relocation, sonoma:        "e60fd70a2e71310f5d92e8dc114be015f97d2b3cdf41ffd845bfe11dcb43c32a"
    sha256 cellar: :any,                 arm64_linux:   "9c34fa9011c3b8689a7448855345a52ff11cfcebc9ed6ab6f2a38af428aba5c4"
    sha256 cellar: :any,                 x86_64_linux:  "2c640d079fc5336e787329f844fcc7052ffac4f0c5dce7f601a96a95c78cbb3a"
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