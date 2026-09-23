class Rsql < Formula
  desc "CLI for relational databases and common data file formats"
  homepage "https://theseus-rs.github.io/rsql/rsql_cli/"
  url "https://ghfast.top/https://github.com/theseus-rs/rsql/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "6b68d37931b47595aabb4d920be64dbd2042afa98b77d071f5db3930087da645"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/theseus-rs/rsql.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cec566f2650f943db78c7baff4df43c60ed5e0c5a6ee859c1df659a958693916"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c81a0a62ddcb71c9365b17d3954cc004cc394105f5e333edf31722af819fa6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e68209a6d3fa6fd007243054a6274f21e9bc285b453675dc19582f5bc5aa32d"
    sha256 cellar: :any,                 arm64_linux:       "8abc40bf045b6da42d8f082ad6e5aa18e367dc23986b58c0da6302b104608c3f"
    sha256 cellar: :any,                 x86_64_linux:      "6f5a7463e4872626cbab42ef99e0eb9ffc47f7839ac5088ba5480c1e80745d92"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rsql_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rsql --version")

    # Create a sample CSV file
    (testpath/"data.csv").write <<~CSV
      name,age
      Alice,30
      Bob,25
      Charlie,35
    CSV

    query = "SELECT * FROM data WHERE age > 30"
    assert_match "Charlie", shell_output("#{bin}/rsql --url 'csv://#{testpath}/data.csv' -- '#{query}'")
  end
end