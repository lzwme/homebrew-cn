class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/1f/43/955ca5bbcfb19599f7f1f3f1fab8d67fc2afd17d8233bfa5f081a5b1407c/pter-3.9.0.tar.gz"
  sha256 "a0fb507e667d0654314a3818723e7369750cbb6628a5c6ec063cab92498eb36f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28d6ed939354922bb449556e17dfa14b963d13bcd28d43a13799f3f32bb217b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9c11406f48c405ddad47a1fd77fd2e3f07a9accd84f3f55418623851fc5e239"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4a158d1fff0e5ba66e9c829bc78176ba687815bc65cd1499580c67129663164"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d4e43a69402835475f19dc6bb76ac1ed1ba0d64b73d5c159820681cc1e77a4d"
    sha256 cellar: :any_skip_relocation, ventura:        "bef794fa835a9c4e14a96050c4566a836ae532250e2fb83db681c3abfab4661f"
    sha256 cellar: :any_skip_relocation, monterey:       "9d211e3ba2a7ce0fd9ddc1e4a2652ef3fba9a3e125d5e924f13b768e39546345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e5e69ce93d870c95f91a74a9d2287a724fd070b264ed3676441a8f233ae66cd"
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