class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/d9/35/247e5568d1e500266bda2601df5b5169aec86bc421e76df298eeb2678fcf/pter-3.17.1.tar.gz"
  sha256 "26a10bca4bceaac4fcd722125bdc0cba839fa16e6abedb2b2de2d5aa626c3397"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0f3d2c26aa693fe5eee88a0f0c43247dfaef3d860bbfee7f9a26c79ae01f409"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0f3d2c26aa693fe5eee88a0f0c43247dfaef3d860bbfee7f9a26c79ae01f409"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f3d2c26aa693fe5eee88a0f0c43247dfaef3d860bbfee7f9a26c79ae01f409"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0f3d2c26aa693fe5eee88a0f0c43247dfaef3d860bbfee7f9a26c79ae01f409"
    sha256 cellar: :any_skip_relocation, ventura:        "e0f3d2c26aa693fe5eee88a0f0c43247dfaef3d860bbfee7f9a26c79ae01f409"
    sha256 cellar: :any_skip_relocation, monterey:       "e0f3d2c26aa693fe5eee88a0f0c43247dfaef3d860bbfee7f9a26c79ae01f409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "967b667b7cf11bb4c28cdcfad3f76da212b9dca117771ce8131a0598d108a093"
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