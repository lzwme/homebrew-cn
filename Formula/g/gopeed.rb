class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://ghfast.top/https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "11df065ca90674f8fd1ab65f9f01157a2cea60bce2ac731c4a7f3ac0ae6fcdbf"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "281fc666edada6006597bbd5dee4b7d75b3d52148c2904f3c4ff5e3b428d24d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b836716678f8174796016a4c43aff911348b9f55da4079ea52763e5b10aee160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cab761744c03749f7d5e1cd9f33daee6bfceb4bf8605872428f6d36ffe34fb52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c695ae3d99da7dc66815515a121f746599e365ee792b1d57359e3e6d04f9b61"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b695d0f59daf315ada606b04449aadce0ffd463a2de8ee790c20f41a1d9d2d4"
    sha256 cellar: :any_skip_relocation, ventura:       "7c577b46f3535e25a6677642a56597e46666ffebf4cf69d0019fe1bdf1bf2b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4edcef2304b6ea48fd920ed74482ffecbf890848b0a4eacfcb25da80ae3e77ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a56511096e47df8ae781bdb346fbe6c3b9bf9d1f4583a6a54813f0849b391a5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end