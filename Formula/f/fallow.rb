class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "9b630ed0e5a99c60a11174b5bba51d2c62e038e338fabf52f4bd6e5986b29d27"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8bd5b42c487e51a1563f67170d49a6399ebbea6d5ee3031f7b3eeb291621ae3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54f0e7f616c1b2bcc823eeef1e05e8795a429f92c040015326077c7ab65ea467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c6e0270334dba0ebc747d72d79e3a9a3515930a94ff811fc32f64117b5220ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4ac032a14016332bd35f8530dd4f720e598e70e27951f69caae9d35656c464a"
    sha256 cellar: :any,                 arm64_linux:   "c144d58cfab6aa77f0d7310f7c1a295a206597776768950e589c7c4cdf4f069f"
    sha256 cellar: :any,                 x86_64_linux:  "eed4ed9193c6f0d950fc60ab3d07b994d63cc51985bde18423fb526ef69f2e8b"
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