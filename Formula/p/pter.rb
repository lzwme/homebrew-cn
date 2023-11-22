class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/f5/8f/76f8d9403215a3cc0438bd0b0c816d437fb7c94de3e60d325509a1f62e49/pter-3.11.0.tar.gz"
  sha256 "1062450af8e72f5fde89f0bcf65ae0907ff97aa67c48ea2df872f05ca9daae31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81c5aed4cac2fe0418019c60ab9e0a0ad11c85f09a32b499217daf58009c4b4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf40ef24db57b2ec7bb5f5ef42abdcd989a622470370a31d1a3104c8f38eef7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c0dfca66cb5e9f544b7aa09b6d51d8df88998d7b2f21581893daa9b402f1b92"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a13e166b29f00ca6913505439ee004b19447a2065fb64a0ff333a0ad2844e66"
    sha256 cellar: :any_skip_relocation, ventura:        "576364900e408a40370a9e31a55f7db38a27b3ef708e741436a3723c7b79a445"
    sha256 cellar: :any_skip_relocation, monterey:       "3f9e4260b11320971848f5056197f0f0cbad4e57af0139b18f14b25ae1a09793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6ea7230e7b380db3d9dcc4531dfbb4f0e7c1420867752c8a78b829121a5969"
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