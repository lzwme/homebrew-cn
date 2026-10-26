class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.36.0.tar.gz"
  sha256 "50658b0b042a1bc67a2411f15d7bbb327d304f13588a21ec029580ef89e3b570"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff2ed279ae364cead1fcd9fa3ceef557d1c3f465d5f91595f01ea7be7890cdff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "472e0b0b9f9d26fde247c2771efc2d520245fa8b57b9a248b54aaa488e809d02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "180806c14ce9e5a8c45417d2324291f15bd39b51b8d9ff435cf2245f7458df38"
    sha256 cellar: :any,                 arm64_linux:       "cc1835a553db222004504d3028009bfadf9a3c86ca6a2917dce8baf4fba1f475"
    sha256 cellar: :any,                 x86_64_linux:      "0e122be3d77fadb0c0213b823c65921e297121d82a5ec39e5391ddf5d2eb6fae"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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