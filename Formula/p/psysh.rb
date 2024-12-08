class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https:psysh.org"
  url "https:github.combobthecowpsyshreleasesdownloadv0.12.6psysh-v0.12.6.tar.gz"
  sha256 "f5aeaf905ca7721bac1b710d9554b67ef48d10dc11156b218042b0200ce6be33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c254452a12e9d64144b068005ef9efe5e98f7dc6dcae61a55ef440958f56c0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c254452a12e9d64144b068005ef9efe5e98f7dc6dcae61a55ef440958f56c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c254452a12e9d64144b068005ef9efe5e98f7dc6dcae61a55ef440958f56c0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "de3c0d50310a3b3c2578fec7c93fafad910d7dbadb5ae308c748e771bad4c6b0"
    sha256 cellar: :any_skip_relocation, ventura:       "de3c0d50310a3b3c2578fec7c93fafad910d7dbadb5ae308c748e771bad4c6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c254452a12e9d64144b068005ef9efe5e98f7dc6dcae61a55ef440958f56c0a"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}psysh --version")

    (testpath"srchello.php").write <<~PHP
      <?php echo 'hello brew';
    PHP

    assert_match "hello brew", shell_output("#{bin}psysh -n srchello.php")
  end
end