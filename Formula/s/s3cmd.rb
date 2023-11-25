class S3cmd < Formula
  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/97/10/5ae9b5c69d0482dda2927c67a4db26a3e9e064964577a81be9239a419b3f/s3cmd-2.3.0.tar.gz"
  sha256 "15330776e7ff993d8ae0ac213bf896f210719e9b91445f5f7626a8fa7e74e30b"
  license "GPL-2.0-or-later"
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91f0b659fb4a85efc0bbd865a694278147af5bc37960f446ceffece363cf02f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e42ed9a9004c1034c99562b50c7b08db318e640604dc386c67d390733e0adba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f065b2850f549fa8302ee14ecb274a86a3bc2873f3d50cddf9021406ef2d7241"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f687476bcd81667ec31fc887f73e56f95a9cbaf358384a3ae913898ca97bead"
    sha256 cellar: :any_skip_relocation, ventura:        "6e0f36edd2ac0d1ca6c8ce7446119ff860f0f4b93c811e57348cba71b555a644"
    sha256 cellar: :any_skip_relocation, monterey:       "6e598cd94e433bc7e8547567759a72217566a040e3755a0e9279a51699d89f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdd7df90fc77cc7d971ce8da3d0295b80174948e8e5f6b4548a1294c19c78c42"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-dateutil"
  depends_on "python-magic"
  depends_on "python@3.12"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match ".s3cfg: None", shell_output("#{bin}/s3cmd ls s3://brewtest 2>&1", 78)
    assert_match "s3cmd version #{version}", shell_output("#{bin}/s3cmd --version")
  end
end