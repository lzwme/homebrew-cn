class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/86/10/3c9a8c8c69ce21665f232cd2e23717e8d77d6b7c2d5c8909e5b550997b41/pter-3.13.0.tar.gz"
  sha256 "874863b71c444b97850bff4b41b0aeaf81fa84a389ef15e00fb279da0c3e5d65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9bef51107ee9a3a16ab32c094a634cbe71d8270df728a6c5128b416861eb587"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1720fdab6184a9005362755ebbabe713b078e55640305f01f673af03e0d623c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fcfb76848184329cd603c657e3f6c6a5388c74c682720f9adf2bf01b125bae3"
    sha256 cellar: :any_skip_relocation, sonoma:         "83394d2aca109bbd6207959aed11b9da923467475b127aaa44fc1ae183f57ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "d3a583f83227cae5c1537c3e2e5fcb25d1a169debb493468590205f8c23b560c"
    sha256 cellar: :any_skip_relocation, monterey:       "bf4f52adc9a6d7e0574da96bde7298959a530dc02c1a7d86ed67bc8e0cca2603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d2d3238839a6871be80852eff0ee3cc94ce317ad664dd176e1843bc0b1fa5e9"
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