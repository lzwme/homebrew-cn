class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "5919a72ffd0b674fcaa665e24f84e4a13dbc622aabe4e97a835fc5c752b9617c"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "762be2aeef9421a2aae7877f6329e1f630448d3fd9a9728ae349b6585ac9d41c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1857621517b1d7eb928cf77c815471db23313124b42628297fb5c0c7f9f07931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7c3adea3bd7f0d922dccb7d7b498a391129110463e704c31f0b06c3d50aa8e9"
    sha256 cellar: :any,                 arm64_linux:       "424824acfa0da8a153e9568ecffac6bf5c869c29b254e611710e15d641d61e04"
    sha256 cellar: :any,                 x86_64_linux:      "d12b16d82cfdb59f7834dc0a9e0dbff727818210f7d75a56a8b6950b8de659bb"
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