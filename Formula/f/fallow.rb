class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "48d3d664f2f7c4a2ee24efd13e57f2bffa299efcbda2ba1186af4f2aa9811613"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5ffd838fc4400646c5ba100d3c69b87340585507d148cd26b2d91fb6359c679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bd890ba32a2e940e5f35efda61373638ebbd19c14ea47da1307ecf6a5af0821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ea89ba946666d8fc2e28fa274f0711ef407db8d6046811fe04e682edfc5fd34"
    sha256 cellar: :any,                 arm64_linux:   "32a4e208a22d2b85779989f20d577b9ddc4a96ab9e94031ac7daaa1933f0d08a"
    sha256 cellar: :any,                 x86_64_linux:  "6192f4f68eb7db5ad2b7018c8cf24341fa8b4d8552f9856c4523c8dbf2e14d51"
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