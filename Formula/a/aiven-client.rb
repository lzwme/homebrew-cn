class AivenClient < Formula
  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/b3/dc/869bcceb3e6f33ebd8e7518fb70e522af975e7f3d78eda23642f640c393c/aiven_client-4.0.0.tar.gz"
  sha256 "7c3e8faaa180da457cf67bf3be76fa610986302506f99b821b529956fd61cc50"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8aa6347005c918084ec5f483b599cc8dfab2a73cdf1cf281b6f59caecf6537de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58429a6c9d968418986836548f98611f744bed68b1f733f37380d7f5833c0eda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79bd9db375396df85f3623745a311faf0c7ebe2d1af975a473281d7192066311"
    sha256 cellar: :any_skip_relocation, sonoma:         "e20aaeb061f534a7786cb310a56a732b8b7286ee0a7a369f64ba746f20117438"
    sha256 cellar: :any_skip_relocation, ventura:        "7c82ef8afaf7bcd0920ae77ec8b758fdf479af52cbd97759ff887b972719b462"
    sha256 cellar: :any_skip_relocation, monterey:       "8950368eaee73ee77b5b20700279057c914fb4b49c1cefc0662518f2d32542d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "047597c18b186cee563ae6f484c1af088134a39c552dfea1b1b5cfbbba75e46d"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end