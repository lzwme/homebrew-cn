class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.72.0.tar.gz"
  sha256 "010aacbaddf8187255e507a0e9a3c46472c291b44a92a445b3e108bb6eb7d91d"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ba46d3480645c48025eae917fdc6117409c2f6cb877c10b03f2cd1030f8eeca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcbb142ea3e6d65deb033c3f53d1b7cd3d7a6902fdc30eb21a380f5c98f2b8c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89a1a9a7fd5bf016023b1330a402cce06df3d731c390ed3cf31b3858b9e037d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec7804c8a37af7466a61a240424d8b0749b69fdf0a2af113146c0cb91eefe82a"
    sha256 cellar: :any_skip_relocation, ventura:        "745f8dab9c5715309a5924cdd0f74b13ebdc46ee1e757981660474663de2852e"
    sha256 cellar: :any_skip_relocation, monterey:       "b1f9c2d62b88650975ece89b54e61302478bcfa8f2ec6f5898e1d66cdae01807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03ec94d24ed436320d81f9c4a12663260186e3ba9404b5c393954821bc1443ed"
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