class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.83.5.tar.gz"
  sha256 "ba34fd3ab56c02da552ee0cc73c4cc9584647c4239d0c585b8512a2edbd3a135"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8076952e592b0fbc8ab87d7d583e4d208b590edec452494758c3739d50bd2b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "151246e1f53a15b983ec918a9a0fad53e8ab68b14b095395d77f0fa71980d955"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "935d77022207cf21c66d770dd636ab6aa3ea3587a757ad32b1213fbe1269c1ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "b56ef10e5488d5e5810586988aceb1d29ca9be0d00ad36e045b93d4b8d81c0f3"
    sha256 cellar: :any_skip_relocation, ventura:       "b435a08236c693dde5276b12306a0e5f962818c20412f1f9fc983fce63ab862c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33fc807c88dd9425e0423273781669143eb37540635cc2bf1f06b28d3d7e7f4b"
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