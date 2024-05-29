class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.77.0.tar.gz"
  sha256 "7c3c0e1dea0c3161634f6682d404e312050f868afcc87adec057534c8ce098c8"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f02e14de5d4f1ceb1beb620cb68e0895679ce296bd923fdeaf8ebcc92701b1ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65b6c5b752cd4c8afae4b9149e15803180f43ee1b81256a232303143a1a3b9df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "597a94148b711507a52415633108ff926a1224ca3609c7bb4b1de351995d08e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "643ec6a4185d0a1182d5334fd8210ff8623603719df51e463f9d50c690b98863"
    sha256 cellar: :any_skip_relocation, ventura:        "813fba1d8eb33f49a72bfd1cf2d13fbf4722611b2ce8e8616053f97f419e5b8f"
    sha256 cellar: :any_skip_relocation, monterey:       "8b0527a3c597ab033f0c135aa14455034a737459238845d1e751f9e4f30975b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ad93e2d0ef16a2cead90cc6486623d39e666553930dbd358cadd1a88ec1ac4"
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