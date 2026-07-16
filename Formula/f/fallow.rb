class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "47e490e15fc399f0d8f7dc5ae920b7aea9299f6a9cfc0423283718f9e7f285c1"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "940af491364fd8a34286851935c0f4ba4f94a80403d16042cf80ff5207ab29f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a00b91c67956d5add9dde37f701b8f3b73ea82460f584abc8cd3467e4509fc22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe40fdd13467ccc96f2554adaa7e86f4314e6610a3b6509b8e8ffff3601796a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e50e18385b56d11ff9881dd3c68cb09ac445f35d3e215268493c4d708a3797c"
    sha256 cellar: :any,                 arm64_linux:   "8e7d60abe1c4cf504819aaec065b2835c2efbea9321d99b358ff5ea3c7eae3a9"
    sha256 cellar: :any,                 x86_64_linux:  "30cc1daba8a76e598d4696560cf43e89d2a84f0bea884dd821309168eaad97fa"
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