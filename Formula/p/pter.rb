class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/4a/d0/02012c84b956751da1996bcb4963ce2e75ea55dcefdce568f95962b669a3/pter-3.10.1.tar.gz"
  sha256 "1ff9eb65b8367f27ad74b09e0b2f2e1c90146b9be0b086d2eea5959af5f7870b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5465c51eec88bec0829ec7f2a3d88f0c78082061865c59e7f37b5e04b871bfe3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c72232d5731544c56b23bd7f5e7e21e15509e5c17080e74c2819cbc866ddf33a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c62c9d72888655cbc5404eec1e056f1c4c19d1ee6b1035fefd950ce0835452e"
    sha256 cellar: :any_skip_relocation, sonoma:         "033e3b4b75fc847b313bb37ae51b8b1540613ee594485f1efaffc2193473350c"
    sha256 cellar: :any_skip_relocation, ventura:        "d09a70a85c10677bb74ed094b2dec9b998ad8d2461e60fecb4a6557514d76531"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5202b4c628f4a7554943b53fbce4fed63f2be1c51eeb0f7818e7f6ac575c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75bae8ba901afb9b3add1e55ae2a710e25c1c2b7248a69b0e8e6ed11e40539c7"
  end

  # upstream py3.12 support issue, https://github.com/vonshednob/pter/issues/30
  depends_on "python@3.11"

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