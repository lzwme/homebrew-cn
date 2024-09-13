class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.82.1.tar.gz"
  sha256 "4cd3b47391ce295a1befd8a6d1faf9f8f72e5c399dff73745896a0ffe3c6f666"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "82e04d0c7ed603e89f3d2a3afd1b4ea130671b8e14292f8098e450e1e6b65744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8646212f2fca9ea82e75688059ab888e1b65fb4d40d3ec1c0c779eaaf88ddebb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8af8651a5cc5c6bb35930aaec27fbed782a1112154c9dc55722d63895042ddfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3c669c6515726cf3b5baf02957c5fb990ba268eb269288979532aff7869e954"
    sha256 cellar: :any_skip_relocation, sonoma:         "201f0f3e80de67bfd120293e13f753d6b4db15f7e76f292fc584e16e4d28b915"
    sha256 cellar: :any_skip_relocation, ventura:        "d7d40686fada3f98738b5c094a77c10315b95c3919d07fb6df7916e177d85478"
    sha256 cellar: :any_skip_relocation, monterey:       "c08faf7c21bf52bc14d3a203f10567282f99bc0a849472d74fb5f621624ec0f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4f7d38b519e140f30d27258d623fb5f66c946352f352563de91f24898ddb8d"
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