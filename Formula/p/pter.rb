class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/c7/bd/d5b3ad7de8a35931fe7eb3ccd171d6e8704b127dbf0e826c49754400772c/pter-3.11.4.tar.gz"
  sha256 "4a417ee4ed52392ce5bd743d5c6e0233ebbac06af617b6eb9fb49b1ef290450f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db85fa8152dc67dc6d292461151a9a9496a8b394f5ccd30def58c749fc9e51c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac67b82975ec5226d2974f7ae782b20b1419d3245caa871f9c0a1c1e7c5cc6bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26b442ee9577d7fa42868ecb4ef2eaef52cae0961c53042e4d9669ae4616468d"
    sha256 cellar: :any_skip_relocation, sonoma:         "584145bae1e2196b11d191203e83df92b0eb75d56788490b765a93de0910fb08"
    sha256 cellar: :any_skip_relocation, ventura:        "58ff793cb6100cba5e3ade71197bead2c921f85b20961ed92e2a80c4c9257236"
    sha256 cellar: :any_skip_relocation, monterey:       "a6410a0cec4e7dd36cde0c5be98a83997c6f808855c5b948037932fd2a7acf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3813f3ed8972283a95d4e86e40fe110162bd3a2c006d727f5f47facab83f1273"
  end

  depends_on "python@3.12"

  resource "cursedspace" do
    url "https://files.pythonhosted.org/packages/cd/3b/72657c9e867dd5034814dcea21b1128a70a1b8427e48c7de8b3b9ea3dd93/cursedspace-1.5.2.tar.gz"
    sha256 "21043f80498db9a79d5ee1bb52229fd28ad8871a360601c8f9120ff9dadc2aec"
  end

  resource "pytodotxt" do
    url "https://files.pythonhosted.org/packages/51/18/a8f4d15eb31bcde441b0ec090c5d97c435beabc9620199e7f90d2f5ad1af/pytodotxt-1.5.0.tar.gz"
    sha256 "99be359438c52e0c4fc007e11a89f5a03af00fc6851a6ba7070dfe0e00189009"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    PTY.spawn(bin/"pter", "todo.txt") do |r, w, _pid|
      w.write "n"         # Create new task
      w.write "some task" # Task description
      w.write "\r"        # Confirm
      w.write "q"         # Quit
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "some task", (testpath/"todo.txt").read
  end
end