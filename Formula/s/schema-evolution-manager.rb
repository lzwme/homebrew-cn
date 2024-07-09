class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https:github.commbryzekschema-evolution-manager"
  url "https:github.commbryzekschema-evolution-managerarchiverefstags0.9.50.tar.gz"
  sha256 "7e84bdb1f7260276254c4bf9942759aa480ca01fe11b81167b6ff736c31765f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, ventura:        "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, monterey:       "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d8989f3ac4c98c6efc1843f12a811bd893d2aeb270da963b2baaa3275b1a072"
  end

  uses_from_macos "ruby"

  def install
    system ".install.sh", prefix
  end

  test do
    (testpath"new.sql").write <<~EOS
      CREATE TABLE IF NOT EXISTS test (id text);
    EOS
    system "git", "init", "."
    assert_match "File staged in git", shell_output("#{bin}sem-add .new.sql")
  end
end