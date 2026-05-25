class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.80.0.tar.gz"
  sha256 "b53ec8888c608cc0adc09a7f2d5dd69d3d39c7ce981733b22923ba1006853889"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7509509ad845e6f366dce163eb0da47ba91038c7c15ee84adbe636dc5c52975e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0705b6ad35c288411dec602c2f51f09cac6b5a4c9265b9961704efd86d7f2c4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de2f37e02f2e421074af8d69ae354c500ce079c42be433adacefc7e138c7b283"
    sha256 cellar: :any_skip_relocation, sonoma:        "17da53a76a888e8d70ac3b442086d1d3736a2bc971413200d31191a938ec2435"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3e13a983f8fa659f4d0871f4843ac12dc009a73bf3ab144a28fe019e68e05dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86141dc354e47b535423b6a939cde6ea0fc3005b88fa3eb0886a7ad3a50cda7d"
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