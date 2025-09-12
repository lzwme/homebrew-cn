class JwtHack < Formula
  desc "JSON Web Token Hack Toolkit"
  homepage "https://github.com/hahwul/jwt-hack"
  url "https://ghfast.top/https://github.com/hahwul/jwt-hack/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b5c0de9923d4ee20037873906223ac14c0c9b1e9623cc3a87e3ce5434d3ca0bf"
  license "MIT"
  head "https://github.com/hahwul/jwt-hack.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ba9109885de2e95de36eefeb4b8a8578d162ffc424080791b00e2ba1a94585f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddd1a44241f3f273eee0f4b4790475041a1db4d0ea1639e9bfaf948e173f3f5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f311059d98670431048818181f3434a1f3b858d8ffe52819f00fbbd4d5d58c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "09afbf532da0113f42a01ea74f8b8394d40786a5b41bfb91d8817b757e17c27d"
    sha256 cellar: :any_skip_relocation, ventura:       "73db99c85339a1b2610d5478f1847d918384a5bc670e9a76b9685e8cd6e5dedf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ab5132ff6af86ba622082a5535e68034b3f1b1a638e6004677d42d09eb29aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1189d0ad3cda89093337bb47ae8c6032246b98a695fbe8cfdbf84385bf12fde"
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