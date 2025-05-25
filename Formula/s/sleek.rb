class Sleek < Formula
  desc "CLI tool for formatting SQL"
  homepage "https:github.comnrempelsleek"
  url "https:github.comnrempelsleekarchiverefstagsv0.4.0.tar.gz"
  sha256 "d4ebd91cfa8478cc5da1e3b5a4ebe0acc4a854970e1fc3638f6dd15b21eccf7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167928a0a7c9453e442272dfa66d34870a8e666844081b36dba1ad1574874b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a3dc714bbab32a087e4a69fc0c713c4b62ee6e38296738103fca4f0de7622a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f11aa3bcb1022a3185ba0751543de27949376416c27851efde099d47c05d461d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c526143ee5fa00f9121b60f68cb1a337911d6121cabdfff0643a8e7319f56be5"
    sha256 cellar: :any_skip_relocation, ventura:       "0107b738533fb0cdba5a62be1620ee746d30970caa0d3e0bd469831d1f45a984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35334f901a1696514f0d7add96609e8ed1ebc7bc0254e516180aecb24edc22b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e6143fa3c94550a7bcbfc1e4b33f6ffb1076057858811317239ed0a37a007ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sleek --version")

    (testpath"test.sql").write <<~SQL
      SELECT * from foo WHERE bar = 'quux';
    SQL
    system bin"sleek", testpath"test.sql"
  end
end