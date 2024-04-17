class Litecli < Formula
  include Language::Python::Virtualenv

  desc "CLI for SQLite Databases with auto-completion and syntax highlighting"
  homepage "https:github.comdbclilitecli"
  url "https:files.pythonhosted.orgpackagesf48794afa9501babb6b1801fa51581689d1854092d5bf949d0aced2327616a65litecli-1.10.1.tar.gz"
  sha256 "37e6801f6be00d5d5853b8881db1ffdbbe9b0817c6c61bb2d9c7962f6cffa08f"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "024331ecc820a4cda1ea19948e6d8c5814817de54a2fca36c07e2a7e998800af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "024331ecc820a4cda1ea19948e6d8c5814817de54a2fca36c07e2a7e998800af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "024331ecc820a4cda1ea19948e6d8c5814817de54a2fca36c07e2a7e998800af"
    sha256 cellar: :any_skip_relocation, sonoma:         "024331ecc820a4cda1ea19948e6d8c5814817de54a2fca36c07e2a7e998800af"
    sha256 cellar: :any_skip_relocation, ventura:        "024331ecc820a4cda1ea19948e6d8c5814817de54a2fca36c07e2a7e998800af"
    sha256 cellar: :any_skip_relocation, monterey:       "024331ecc820a4cda1ea19948e6d8c5814817de54a2fca36c07e2a7e998800af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "425db02d8f693218b50fb6605ea95e1b9a4b1bc30bcce4fd3d748dac5d033016"
  end

  depends_on "python@3.12"

  uses_from_macos "sqlite"

  resource "cli-helpers" do
    url "https:files.pythonhosted.orgpackagesabde79529bd31c1664415d9554c0c5029f2137afe9808f35637bbcca977d9022cli_helpers-2.3.1.tar.gz"
    sha256 "b82a8983ceee21f180e6fd0ddb7ca8dae43c40e920951e3817f996ab204dae6a"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagescb8717d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fbconfigobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlparse" do
    url "https:files.pythonhosted.orgpackages50265da251cd090ccd580f5cfaa7d36cdd8b2471e49fffce60ed520afc27f4bcsqlparse-0.5.0.tar.gz"
    sha256 "714d0a4932c059d16189f58ef5411ec2287a4360f17cdd0edd2d09d4c5087c93"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath".configlitecliconfig").write <<~EOS
      [main]
      table_format = tsv
      less_chatty = True
    EOS

    (testpath"test.sql").write <<~EOS
      CREATE TABLE IF NOT EXISTS package_manager (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(256)
      );
      INSERT INTO
        package_manager (name)
      VALUES
        ('Homebrew');
    EOS
    system "sqlite3 test.db < test.sql"

    require "pty"
    output = ""
    PTY.spawn("#{bin}litecli test.db") do |r, w, _pid|
      sleep 2
      w.puts "SELECT name FROM package_manager"
      w.puts "quit"

      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end

    # remove ANSI colors
    output.gsub!(\e\[([;\d]+)?m, "")
    # normalize line endings
    output.gsub!("\r\n", "\n")

    expected = <<~EOS
      name
      Homebrew
      1 row in set
    EOS

    assert_match expected, output
  end
end