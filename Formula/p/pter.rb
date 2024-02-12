class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/99/7e/43e46aabede195064760769ea73db0aa55f45992198fe418eda635f1824d/pter-3.15.0.tar.gz"
  sha256 "74d91caba7bd2391467a75e893a14b205870aee89c680fd4996cc119a26fdcc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25afa9a34f99ba33c8cee7d635c85bd0f186af446ad3d5be7d32e91914ff2765"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d98a4343a6d57c45d9333f291d3b023b2f377217ba548f87f50d80bd9159e5b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe203250c5b8099e40dd244e09879cfb538936de7db6f869c0af1622ec40c53c"
    sha256 cellar: :any_skip_relocation, sonoma:         "50510fca9c8bbee22d3800bcc2c0c7ecbcb5340386f5d3c8aabc8194d36c6f66"
    sha256 cellar: :any_skip_relocation, ventura:        "3bc0d9f6df8d1ce488bfe14eb77b64caea59a75553453b92de5b2af7e38035e4"
    sha256 cellar: :any_skip_relocation, monterey:       "b6a2de3755b6975df2a6c1b54c5c6f30af372b2ce120e211954e186677b4eb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c676930028055d0c431561b94905c259a10798929779ed1f67a2eea8296612d2"
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