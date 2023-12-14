class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://ghproxy.com/https://github.com/phylum-dev/cli/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "6d690a17be074ba2c174bd03868665332dead3deaa35fe9b1fcac7a1f4d416bd"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad346082a054091e9eb8b5d5a5bea242d86e7c3aab0dd3f05d9ffed10df61bca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d1bd88de7f008ab0b1a074b4eaa9db01b40bc62f9f18ef2f42b81a2bfedb2b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4076fbdc95f25c2a32d86bce23f75266117f540cd323e397925f2800b47a87b"
    sha256 cellar: :any_skip_relocation, sonoma:         "61c0536a80ef5bc2583bf3bc4b3528e893b8656f2706f5a1608712bed770d6f8"
    sha256 cellar: :any_skip_relocation, ventura:        "e456e24e744c2fa91fc8dd84f7b4b8cf96965991dc6533b4d517d3781d70a001"
    sha256 cellar: :any_skip_relocation, monterey:       "e97738f39157d0a06dbec6d2f1aa3bf415421dae661aa9a90da881b209683110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c086f266e8542d956e8ee76cb75980f5dffa00d82137a4648ef29fe00c61e1"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylum version")

    output = shell_output("#{bin}/phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end