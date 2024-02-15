class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/78/f4/01184064e86fc05202c31c0eaf5c48e6c627f6b0c610a758081ed9af4a72/pter-3.15.1.tar.gz"
  sha256 "c0ae59118f25f57b91ba349238972354794928d7db7d75c5b10ea3e28d5d8600"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1db38c18a281f3cb1f12323ccf22969bc95e41a3246da469b6d125ea77131fe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c0ef2ec7fc4318ca144a270c0794b72d9fd7edaea6d9476e07b74092ad99a75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e701f0c5bc5c3393e8a13a18c94cffe937e9e673a28bcd1ee2ab05eeea76820"
    sha256 cellar: :any_skip_relocation, sonoma:         "57e5548facfcd320b746b4debeed3f967984a4ae30295b7d3a1d18d72dfb8c17"
    sha256 cellar: :any_skip_relocation, ventura:        "f40f892d5c2d5eb95c9aa5a4e4b093ea261da8b98270b389a37367a94be20af7"
    sha256 cellar: :any_skip_relocation, monterey:       "f58ac6a81bb286c091034f1e6705bf29c3f158d4941850251c3032c0ddf24bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e3bd4e443f6742790a3191faf3a60b452144eae8c7c54d278004902858bc00"
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