class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.86.0.tar.gz"
  sha256 "e4dfecc7899c2e7513689679f6463a9744536d3d6c2d29c8a88faf171272540c"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "378d720f3a6b9eb534523eebc6d83bef76c254bf505e49f5e698402c6d183189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed8b86d215fb77f20cea54643e737915ca239ded4147675aa83774952aa298e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fd0fb3e98757e19a2fbd2fc54c3ae24937db9a9bbefc9fc92034e31dc0ad610"
    sha256 cellar: :any_skip_relocation, sonoma:        "1afa16ea5709d31e5d31c35f962da43ce4f20f26ab2058c6e11beab6fb7a95ac"
    sha256 cellar: :any_skip_relocation, ventura:       "19a6e87e90b52fe4f3450b90ea3d7f64d921ace55fca4859660d602e6366f83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b44a184b335482311994398bc4434f89d002cc3cab57a06c87975f0e024f06"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end