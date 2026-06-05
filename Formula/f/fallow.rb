class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.88.3.tar.gz"
  sha256 "fb90b4f2357dc8422de7b6e3cc1b5713072d9af7c8743412e233eb5cec30602b"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5205feff5545f725847f3cdf1500c498a7103527f4bebabad0ff012f70b6a58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7680d313a4ed1653cdeb62b86915f646812f43f46d6fa041a563834373e37c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71f9695d4bba52b32c6f6ba01a229bb4d34c1bf29691666ad2105719ed11dade"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7b314a331181342503eb7e08cb6b0bc783ec80bd82b24c6f81b6d22543e6d31"
    sha256 cellar: :any,                 arm64_linux:   "f41caad6fc30aedd100057f96a1602f959a600a268cbfd268525044cd70f33ab"
    sha256 cellar: :any,                 x86_64_linux:  "bd16beb5f3f7c0536c9cca3a3979a1c74e53254a2003b0ce46dad7cfc8a8791f"
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