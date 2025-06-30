class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.11.0.tar.gz"
  sha256 "6b43d6d70067c76a8b7d24590bbfa1b83405bdf129d01cd5ea7a45b1a09f5f31"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bbec79187bfaa6558c482e6c947964814899fc4ee3ddebce43f7642211f2819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "882a4afff7281424c12610723acbbb30cb8d624efebb4f9e54aa476c580da4f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bcb66c1b95872b44df380b453c3327ffe18d10c9d46396f4de82207e7d2ff02"
    sha256 cellar: :any_skip_relocation, sonoma:        "a51d4e12b00cf8cf565830e7dfb32ce318618d0cea30bbc11c0c822777f384d9"
    sha256 cellar: :any_skip_relocation, ventura:       "e9b4cda0ebe089747deb2d8836a536c7355849643fefa8a687a502fadc31b057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adf829d2efe92e438b38172e14f896f87b46054ec16c49367c5ffc621eb374f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e3b3ca614eea9619044dd26f56d6c88f38b056b2d77eb821f65db14be741173"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end