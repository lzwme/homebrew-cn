class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/a5/9b/982451aa94ac02ab5c48fb67383af408373a1413225cf4cb052d6e66287e/pter-3.11.1.tar.gz"
  sha256 "0d4dcf287d983eef010a86fe45b02c8b397a197040e5cf1b9174ecc46266e7cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c7bc2b10577f0b8aa73c0d47dc6e4806c0bca9771b89b0569ad9173b78382db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "028810ceb9c94178b3f8abfb467ab7af40b5bc498fada719d105f9818ef666c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95cd60820740715be74004648b000b3cb2c193ab48bde5a9da0ea7b8eae2ff31"
    sha256 cellar: :any_skip_relocation, sonoma:         "27cd47f391b8b063dfb8f1ad52af154e65472e850c7f9534e3498a5afed38ffb"
    sha256 cellar: :any_skip_relocation, ventura:        "337f1c39c93741930c0dfbcd5c153f4f4bc42b821405565f932d10fcfe3f25b2"
    sha256 cellar: :any_skip_relocation, monterey:       "8adbd9fc9168b12f8086b5fc392b34a5d132a4f336ab87f50a4ed31351d05dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a7a7e17bb2e5593c41c3e2adcf7c7d92819fd571b129726eab69b21891ab9ea"
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