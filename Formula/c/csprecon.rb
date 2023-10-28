class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://ghproxy.com/https://github.com/edoardottt/csprecon/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "0a722fa9cc16c408eeb1cbf4e884a061407aa7a5d24beeb7d9bc8ceecf214d4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc6ca1765adff425424c17ea1ed5350be3b7466c077bd444d9b164ef0bf5da5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c9ee3f274f8d0ba3bfcdd799a91f197d4e30581c054bb5b8623458fcdabf5b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a4816cdda80ea24142351d23c7399183c7640a3b9ccdbe8d08239ac83b7c20"
    sha256 cellar: :any_skip_relocation, sonoma:         "09fcbb93988581981ec220eb78446489eab7ac55765cfd45dab8dcdba133fc67"
    sha256 cellar: :any_skip_relocation, ventura:        "ffc59b024832453f4921b827d4b79878776f174c0954dfa26392d3f2cd0c1220"
    sha256 cellar: :any_skip_relocation, monterey:       "54846d6a2f921f1c52b6d164611d0f46d24a496599dc7c996209953dfff2d813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e23a468c5c572f231c1e752b3a8383ebff527b90c9c1485378ca63c3025666a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end