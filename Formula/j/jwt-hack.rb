class JwtHack < Formula
  desc "JSON Web Token Hack Toolkit"
  homepage "https://github.com/hahwul/jwt-hack"
  url "https://ghfast.top/https://github.com/hahwul/jwt-hack/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "37af0cf465b6262c6ce618d88f0122df5c536613cdee8addee5990b28558f56c"
  license "MIT"
  head "https://github.com/hahwul/jwt-hack.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba40e6633b5b0f8f20ae555897eb6acadfe6905e763940c8968ae00183d32237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f26967e9af7f4fa3b481e87ee98336ee8c2e641b4c229e36feb64e26e9d39cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c2d51b3e7cd459b60d2efb1de8d657a361bea8a530f753df29ec4d9f2599d3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eaf110d211f17231dd7b28924b661072726c17ffe1cb5e2104f3be00e5019cb"
    sha256 cellar: :any_skip_relocation, ventura:       "02d8edf96689bd9d6108945e8dedcf683b6ba4d93aadbdf65c7fa26badda2fd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3292f5cc168427af341a83542a04bb967353d3c12c81f760bac2dc53805cc10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "336276b55af948477089877d619450a2af45bc076300fb1c734060418542d3fb"
  end

  depends_on "rust" => :build

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