class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.64.0.tar.gz"
  sha256 "d87c010aa3354516fa91974040025cea1995caca8ec3ecbca7a9ea1a07a255a9"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e281b835b2b2f67c6e43573f74f62f6d93f5f5e9b5cde79d4e0926ba1c59d34a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "376742e613768af99f4eca1fbe2816e7383308229c07f7c18e3b1b047400457f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6166d79743564408c40e526e807e0c6de0e1af0fbc26a9a69813b9dadd2ee0cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e590d3cd4513d320e3e15cdff14da0c5df00f0167be18e6a2ed9478e1ac1be20"
    sha256 cellar: :any_skip_relocation, ventura:        "af185c1bbd124624536053ed37a8f4d173145a066048bf57d7f727e73f4e93a4"
    sha256 cellar: :any_skip_relocation, monterey:       "99b2ccbc33e8cc3bf1456636e35a31ccbd19757c48ba119c7f9cda8e7e3465b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8f3102ba9f653d9f8df445d23479165a526d6d63afd56f560b6d2c3fcafa1e7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end