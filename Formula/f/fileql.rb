class Fileql < Formula
  desc "Run SQL-like query on local files instead of database files using the GitQL SDK"
  homepage "https:github.comAmrDeveloperFileQL"
  url "https:github.comAmrDeveloperFileQLarchiverefstags0.8.0.tar.gz"
  sha256 "3ff4541e28e385a97848a818884121a6cc1c80e2ee5ec11dff3c93b3215c85ef"
  license "MIT"
  head "https:github.comAmrDeveloperFileQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42e315ced5bd6d82a7baecdd50304566600034959bd6a64dc7e026dee6772352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff1ea61b52151a6a322a444172c8b2590742feaa3b2b3dc3df9edd300d33b842"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "533aaae780a28a1aa2a130f327dc208c9f055bf3791565aa8cfc29d8e1acf51c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a73f33692cc2ba9c6da37b0684d0b9bf0933fdafaae9d1389182500d3132d33"
    sha256 cellar: :any_skip_relocation, ventura:       "96e5e38cc11b42c582298bee79d835ed8242dd5736fb4fe0413fc68079d7dd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5ffd55b9a56dab1037d6275d385d216fd5ca51f2e4fe46750ec539602d2ea39"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = JSON.parse(shell_output("#{bin}fileql -o json -q 'SELECT (1 * 2) AS result'"))
    assert_equal "2", output.first["result"]
  end
end