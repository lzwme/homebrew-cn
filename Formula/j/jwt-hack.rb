class JwtHack < Formula
  desc "JSON Web Token Hack Toolkit"
  homepage "https://github.com/hahwul/jwt-hack"
  url "https://ghfast.top/https://github.com/hahwul/jwt-hack/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b5c0de9923d4ee20037873906223ac14c0c9b1e9623cc3a87e3ce5434d3ca0bf"
  license "MIT"
  head "https://github.com/hahwul/jwt-hack.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5c28d9090be92f5ae472584d4c6b2dbb2c038bfa6e2f148023345fe40f468b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "853bfed2699d13d7956f451870fe7adc10954917a16c80c0bdb812e7fc0b864e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d5c90a3426e9cc07efc5ebcb7050cdb82b63e1ac7e5ae0ac316b017e65c13fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf365d16377f64f9ecb82e2fee811ede310fd4af54c1dedadbfb3fe9e31462d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94da9d3f057a84f868453aff625fefcd9ab1931fda4c3507b03af3409565e174"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" => :build
  end

  # add missing fields, upstream pr ref, https://github.com/hahwul/jwt-hack/pull/77
  patch do
    url "https://github.com/hahwul/jwt-hack/commit/7e607dd3d261a1a97e4bf1a056aecd9a3ba2f686.patch?full_index=1"
    sha256 "52a71652d0621103994e175eb29ed26991e5fcfba459feeadf66ecc07688eb56"
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