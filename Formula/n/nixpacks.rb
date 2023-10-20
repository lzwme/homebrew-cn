class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "25b8b61db06bfadb42a84492baed213dd05341f06b153602d8a26f097ae51a69"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f61dbd264c2849fe21d44975d7e57244a51af5a7bcb00a30cf8bd353be127b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d96d140c8d2983b71ee11c4919ba8390792be006bf409cf38400c42e2ce6bc09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b94ce099f802b2c8181f076a18e8fa72b0946fc488ce9b29f17c458f3c0257"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa6655a6eb8f11c8af81d4be8c2ed54e549574b7fd2c881392e759352a688609"
    sha256 cellar: :any_skip_relocation, ventura:        "6f0b7d80c88e9b2835d9c11696296fd296d4c96fbb1bf7c8aac889d39530ec2d"
    sha256 cellar: :any_skip_relocation, monterey:       "4b6da0f088ba3cbad57aa16f0fb58797165597f104320425b9485a69916bc81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d6999db44032bd0a9e8c4ed04741187834de074866b49fd59ce16c3f0115c4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end