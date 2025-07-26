class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://ghfast.top/https://github.com/mbhall88/rasusa/archive/refs/tags/2.1.1.tar.gz"
  sha256 "51d9db364b11f390ea84fff0f397b5bb874cc301cf5e263fdceffff90f8a7300"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e59eef8cc75cac6aad1f47d4a90a81713018df984f6e413850de5a4a3780b00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ed505681c505b7f564af4a4b21716b46aefea7d67c5cbd9f73b02110a0cf6a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d09cf5116f0e47081441e30a6490c9a19df8f9715f0a6d312d1fe0dcb7ff2c5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d08013197d2a1eb4ade2f7ea7f0b518e0f73f48c537a23d02df90da4bb09dd"
    sha256 cellar: :any_skip_relocation, ventura:       "989e9071c73771b5ca79fa4ea555e814491846d36b274662dd679bd355705a11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d86f18f1566ccaa128fe9ec43a1a3698baf18b9a300d71aa16bd3a6747ae407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23596119bdac9d3df5fbad7946787df1596b076e9e7174dafad43382720ee8b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/cases"
  end

  test do
    cp_r pkgshare/"cases/.", testpath
    system bin/"rasusa", "reads", "-n", "5m", "-o", "out.fq", "file1.fq.gz"
    assert_path_exists "out.fq"
  end
end