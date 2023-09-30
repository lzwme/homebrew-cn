class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/cc/3d/6fc7f754cc7f76b4392a781dabc3029bff9cc43efbe59e7a1cd534f51fbb/pter-3.8.0.tar.gz"
  sha256 "29672889f0a2fe77a327621a436f0a7a08735fea923966d905f9d1e615815334"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9a9fb8fe3ce2a59e9e5fde58b927438fa53051fdef5ac3011527bbd4d3f0a7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67e60d35c745292727261f6f0948051b69ffc7cc3e55747e83b9bbb2f63da3dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0be0b3addf7b0367c3fcd2e84ac5d30a7ae6210b3e96085b9c5d719de3e59e49"
    sha256 cellar: :any_skip_relocation, sonoma:         "343b8dd67d1235a25c6322dec7efc1e8cbe87431b9b358fa22106cb81daed254"
    sha256 cellar: :any_skip_relocation, ventura:        "6a033cc775af0d571f72cf1c2734cd51c765164ae6d118f9e1b75c250a1115b9"
    sha256 cellar: :any_skip_relocation, monterey:       "3bb569c79fae91d5e0c5d48296759e1c8bce4651108b6cf9dbf19a978aa388b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa36fd9f0bfb9508b1a1830ca8904200da3cdc464f3f7ea3f2c2ec2dcf49b7dd"
  end

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