class Bomber < Formula
  desc "Scans Software Bill of Materials for security vulnerabilities"
  homepage "https://github.com/devops-kung-fu/bomber"
  url "https://ghproxy.com/https://github.com/devops-kung-fu/bomber/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "bc5e372d6f336c54f676fa9c7f39f20983987590b826962eca1e4a16109cc8f6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f227ef01b9e4064d7b6cb945dcb65bd39c3748f4aef594aab4fc91c269bce55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa1d253d6c46a8ae70849f9aca42152bbd3893da782538c0500f076af03bdcef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f5f1e955942385652beb07d44d542fe806e5e1d504a43607b4aa462a3279c72"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1f7371b26619cb2c8fd7f363233cb3791c237ef601990c5135eacb121f85011"
    sha256 cellar: :any_skip_relocation, ventura:        "4fdf488a6ddb274979daf263ff37f2f33a76f28d906a6f3b042ffbfa4e10f3fe"
    sha256 cellar: :any_skip_relocation, monterey:       "e8399f08a9b353a32e8442a7afa166bd7f84799f60aabc2faf4398b51596c4e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad78e54d44f14b88f2c6ceaf634f8160270bac73f34f6b1af8b56d50be23b96f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bomber", "completion")

    pkgshare.install "_TESTDATA_"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bomber --version")

    cp pkgshare/"_TESTDATA_/sbom/bomber.spdx.json", testpath
    output = shell_output("#{bin}/bomber scan bomber.spdx.json", 10)
    assert_match "Total vulnerabilities found:", output
  end
end