class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/96/e6/b38eda16e915ef5062ff717b53025a18769bd4bf56f753523b54ebee1913/pter-3.19.1.tar.gz"
  sha256 "a75347102bbf6aa7c89012a22a4b4423ea137cf5c423ff750be394c2ea299684"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "356cd38bdb434ebb968d731616914d35991af7ec6a3172c303d875c70abfd18f"
  end

  depends_on "python@3.13"

  resource "cursedspace" do
    url "https://files.pythonhosted.org/packages/cd/3b/72657c9e867dd5034814dcea21b1128a70a1b8427e48c7de8b3b9ea3dd93/cursedspace-1.5.2.tar.gz"
    sha256 "21043f80498db9a79d5ee1bb52229fd28ad8871a360601c8f9120ff9dadc2aec"
  end

  resource "pytodotxt" do
    url "https://files.pythonhosted.org/packages/be/b7/dad26d5ec8ff4c0e6ed37414f5d5de53c3d9ceab67e077606e5a1ed44ea0/pytodotxt-2.0.0.post1.tar.gz"
    sha256 "bdbdfc17840b18903d37784d1c58c49fdd8127323d9b6234e3992a74eea80310"
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