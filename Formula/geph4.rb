class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://ghproxy.com/https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.12.tar.gz"
  sha256 "85624313847c8625e5c6d496e973bc47ef384bf7526fce2b557fb297d823dca4"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85a5c2bc31407cb0d24e2ae8cb92d21ba2ce0219c9963394c85fceb979ce2973"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27e63f9f21cb92ece4e8eb830e416ba2a2fec973e4b5354397a1d59e9eb1cc82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9685484a84ab3691c77874bf2d655a9b5f2e335ce423d16a0c9503f1a7ce5a51"
    sha256 cellar: :any_skip_relocation, ventura:        "beeb2bca801566bf12a91de528b5e51f0cfccd850336cd74e42c83476a88ccf6"
    sha256 cellar: :any_skip_relocation, monterey:       "caf47cd6584dd517e931883d6ad9272d3cafafa46b01484dd5d3ae8f1142bec2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fc327a5d694c381528e13be51b5d4af2f4f4cda1b14c1d3f836f5af85a4c317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfab5e314d6c18cb950292890f556e955fc2946c77a31b3b4cb03a7a9134f2e2"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end