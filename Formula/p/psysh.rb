class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https:psysh.org"
  url "https:github.combobthecowpsyshreleasesdownloadv0.12.5psysh-v0.12.5.tar.gz"
  sha256 "ad00c357f66f5b6f47eccd8a4dbe5294421a39aff50ad80f746b51a7e714cae6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7abb6a8e64bcac85e0c8553ad0ec240b1fef900839aebbd1b7b0888cc3c2c7f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7abb6a8e64bcac85e0c8553ad0ec240b1fef900839aebbd1b7b0888cc3c2c7f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7abb6a8e64bcac85e0c8553ad0ec240b1fef900839aebbd1b7b0888cc3c2c7f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c1432334912261eef9739f87bdc14b4e83ad7486de1b21805fcbeab8d70172c"
    sha256 cellar: :any_skip_relocation, ventura:       "5c1432334912261eef9739f87bdc14b4e83ad7486de1b21805fcbeab8d70172c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7abb6a8e64bcac85e0c8553ad0ec240b1fef900839aebbd1b7b0888cc3c2c7f3"
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