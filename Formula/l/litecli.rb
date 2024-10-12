class Litecli < Formula
  include Language::Python::Virtualenv

  desc "CLI for SQLite Databases with auto-completion and syntax highlighting"
  homepage "https:github.comdbclilitecli"
  url "https:files.pythonhosted.orgpackages4d1d4e033f1f9777c734d1fa6503b73c486f4bd8b574dbec47ba03ababb62fablitecli-1.12.3.tar.gz"
  sha256 "dd707c1bc04047aa6dba1916d204be47003aa383cf638bbe0f1d70bc6571d681"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d00646d4b1880f440b30e92cf4f7bb5765dfb407bca8e3a360ff568a493044ba"
  end

  depends_on "python@3.13"

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
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages2d4ffeb5e137aff82f7c7f3248267b97451da3644f6cdc218edfe549fb354127prompt_toolkit-3.0.48.tar.gz"
    sha256 "d6623ab0477a80df74e646bdbc93621143f5caf104206aa29294d53de1a03d90"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "sqlparse" do
    url "https:files.pythonhosted.orgpackages7382dfa23ec2cbed08a801deab02fe7c904bfb00765256b155941d789a338c68sqlparse-0.5.1.tar.gz"
    sha256 "bb6b4df465655ef332548e24f08e205afc81b9ab86cb1c45657a7ff173a3a00e"
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