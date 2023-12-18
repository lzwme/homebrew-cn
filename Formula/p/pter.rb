class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https:vonshednob.ccpter"
  url "https:files.pythonhosted.orgpackages9a51804f61e32b6ac5c4e84bcb9c72e748e49cb96940abb97bc823fb747f69b4pter-3.11.2.tar.gz"
  sha256 "563bab0ba753da631c968fd0e7de8b203873d70f5205ffcac34ae74ae63322d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adfed4610d4f20bde1b2b30ea487ddeb090baa2fcdb7912c34b12572353917b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e59a2b5a3ea6ec1cd0cd7667feaa7f2f2edb1e7390ffd110f60e95326379e79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba2d0a05dea6640baaf5d2b15ca3dc3f9163aec1bc97cd0f8bca24a8ba5b347"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3ed2c98b19ebb7354a524fa61b0241964eef372723109899540f9b887a68e12"
    sha256 cellar: :any_skip_relocation, ventura:        "881e5e83d9a4bb7ac648b9040bb57bba8727c2686d39e9abcd3c4b56c1c13379"
    sha256 cellar: :any_skip_relocation, monterey:       "18819a0716a8429dda5800b92497b9a803bd68c91d66d98118adcd5ab9f559ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd38a2e3495e1892471312829f1c4f2e5f00e12ebc4af4585b8056e406bc4e6"
  end

  # upstream py3.12 support issue, https:github.comvonshednobpterissues30
  depends_on "python@3.11"

  resource "cursedspace" do
    url "https:files.pythonhosted.orgpackagescd3b72657c9e867dd5034814dcea21b1128a70a1b8427e48c7de8b3b9ea3dd93cursedspace-1.5.2.tar.gz"
    sha256 "21043f80498db9a79d5ee1bb52229fd28ad8871a360601c8f9120ff9dadc2aec"
  end

  resource "pytodotxt" do
    url "https:files.pythonhosted.orgpackages5118a8f4d15eb31bcde441b0ec090c5d97c435beabc9620199e7f90d2f5ad1afpytodotxt-1.5.0.tar.gz"
    sha256 "99be359438c52e0c4fc007e11a89f5a03af00fc6851a6ba7070dfe0e00189009"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    PTY.spawn(bin"pter", "todo.txt") do |r, w, _pid|
      w.write "n"         # Create new task
      w.write "some task" # Task description
      w.write "\r"        # Confirm
      w.write "q"         # Quit
      r.read
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end
    assert_match "some task", (testpath"todo.txt").read
  end
end