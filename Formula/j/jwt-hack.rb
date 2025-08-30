class JwtHack < Formula
  desc "JSON Web Token Hack Toolkit"
  homepage "https://github.com/hahwul/jwt-hack"
  url "https://ghfast.top/https://github.com/hahwul/jwt-hack/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "d54521395e1ba6a633e9ce032efd8c9f4574c48103ae976b5d0c9951f1b4bb70"
  license "MIT"
  head "https://github.com/hahwul/jwt-hack.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69a31c9198ac7daad5cd785dfad52cd4113d5d7de56eea777e5802d891d72b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b62f73cca8c83daa8fb3536df4b0bce20efdf05b256a1bb08112d3534911c78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43b743574548e6497f6bf8a46cc0ce538130dd350c0bbe7db561b25e27dc0f18"
    sha256 cellar: :any_skip_relocation, sonoma:        "1001e4f95a48c7320e674557afec4147bc1c5d984e2d878ff1ad49e7c495ac68"
    sha256 cellar: :any_skip_relocation, ventura:       "9201954f77305c88323f3528338eb3155785243f8edbdddc5037da6b50011753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27f8ce03b3ec9939013af4aba0326ea60fb4080a45a18920fc35ea0674b090c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14933f90231ec409de0f9bc081612c3fea2f0db625ae8a7e67526f179563d5cb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "jwt-hack #{version}", shell_output("#{bin}/jwt-hack --version")
    cmd = "#{bin}/jwt-hack encode '{\"jwt-hack\":\"hahwul\"}' --no-signature"
    assert_match "eyJqd3QtaGFjayI6ImhhaHd1bCJ9", shell_output(cmd)
    token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikpva" \
            "G4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTc0OTI4NzU5Nn0.6Z458qcvAJFTH9XCBgfmwgmqupsrefK8ItGYfyH0Ipc"
    assert_match "John", shell_output("#{bin}/jwt-hack decode #{token}")
    secret = "a-string-secret-at-least-256-bits-long"
    assert_match "valid", shell_output("#{bin}/jwt-hack verify #{token} --secret #{secret}")
  end
end