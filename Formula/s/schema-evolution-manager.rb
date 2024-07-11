class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https:github.commbryzekschema-evolution-manager"
  url "https:github.commbryzekschema-evolution-managerarchiverefstags0.9.53.tar.gz"
  sha256 "699a184a2725ce6cd878ea219fba4c5f7ca937c44386435c24fe0a9c9c224445"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68e92c7419b1938535058bdacb7317801df1869745f72f055bb419d166414ff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e92c7419b1938535058bdacb7317801df1869745f72f055bb419d166414ff1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68e92c7419b1938535058bdacb7317801df1869745f72f055bb419d166414ff1"
    sha256 cellar: :any_skip_relocation, sonoma:         "68e92c7419b1938535058bdacb7317801df1869745f72f055bb419d166414ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "68e92c7419b1938535058bdacb7317801df1869745f72f055bb419d166414ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "68e92c7419b1938535058bdacb7317801df1869745f72f055bb419d166414ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568707ac58d57d539ef383eae2fba642adb3edd7f5f9b9317ebb245baaed674b"
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