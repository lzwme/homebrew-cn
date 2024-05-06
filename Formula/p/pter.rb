class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/77/3f/12d1e52a5d2a85d992dab83fd80f81564df6eeed99a2f78beeb0fe2f2b7e/pter-3.16.2.tar.gz"
  sha256 "809a15b177e0009ed70cc179bdf62165e4d06683046fae2f3e60c3a602f396bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbee495a8a62ddaafc0d60cab5127e907d792065b71255d8719de4919cc0dab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbee495a8a62ddaafc0d60cab5127e907d792065b71255d8719de4919cc0dab4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbee495a8a62ddaafc0d60cab5127e907d792065b71255d8719de4919cc0dab4"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbee495a8a62ddaafc0d60cab5127e907d792065b71255d8719de4919cc0dab4"
    sha256 cellar: :any_skip_relocation, ventura:        "dbee495a8a62ddaafc0d60cab5127e907d792065b71255d8719de4919cc0dab4"
    sha256 cellar: :any_skip_relocation, monterey:       "dbee495a8a62ddaafc0d60cab5127e907d792065b71255d8719de4919cc0dab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cb093d303435b141486dd535fe314f7ffdea6e5009a4af6d387b39521557342"
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