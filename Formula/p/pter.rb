class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/2c/23/138875969e4f4c2893baac7765767100f84e1adb9dc0cb42c3c5f08d42a7/pter-3.14.0.tar.gz"
  sha256 "be223dc66e5428d9e2e593a3ce5fa29e36e88ab745476f9dc7661a97a510f9a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7885a8cbef91eb399cfc85ca2fb5b77762a44a001b416fc7db5bcb071b280fc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c5536522fa7f6cbbcc7b81e888011a2c0f98e99635bb2de827b8c1cdd407bb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c1e051464304de0b895274466ad280504b6bc3890f9e31b4c46059301efa8ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbc64df504d28ea0031dc744f2d762ffd7f04879d3c3129f4e87ad3939dc4386"
    sha256 cellar: :any_skip_relocation, ventura:        "2000765e5b4f45f9ac159c80c470740bfe419b061e91455233aa4e75242fe336"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a21c0e9d7d17cc1c54342e5a651007f1a3fe7e42e327b79d4a40c2633a5aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1edb93e878ed41226d04bc76607f1c380f2aa3479b9905d8efca86ee022b44b1"
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