class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.98.0.tar.gz"
  sha256 "163491646926aad1c0f05aea458dd7480fea1ff5f671326490b9c98ef64370f7"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6de08930aaf88118d3dfaf7be36cbbba620c9b6b83a9e4e52902bbf2e244a239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bf136e4f82139145ba808fe5ffd9f406313524351baa38bb37218a950ea09f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a69ebd86ded20bb0ae1e76ab24d5f925ec65451fdcecb29f9da7b6ab14e7f577"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dc136ce09ddc1e78ed622c91485f5e70675d3b39850b93ab51c16f933edc2e5"
    sha256 cellar: :any,                 arm64_linux:   "eaf2a3dd032e6b48398e117d1d5eab61d347e9f5e70cb8915907dde2af2c9888"
    sha256 cellar: :any,                 x86_64_linux:  "348fd209c05e34d88012dde5a5c3a1a68dfe2ef81f4c8f1542cdd8d14f46de99"
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