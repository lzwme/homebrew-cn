class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.71.1.tar.gz"
  sha256 "04ff897c9f845e14641b37ea607c4b9f7f7374e95054ed6437de661e48e13cfd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e60502a3be87bf223fff1fc0bf4d397dcc2581f16db8a007b4c84760235456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e60502a3be87bf223fff1fc0bf4d397dcc2581f16db8a007b4c84760235456"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21e60502a3be87bf223fff1fc0bf4d397dcc2581f16db8a007b4c84760235456"
    sha256 cellar: :any_skip_relocation, sonoma:        "041bef2356d0a5a146e595e6f01610aa4ef1bfe0914151aeeb603f395f03bb76"
    sha256 cellar: :any_skip_relocation, ventura:       "041bef2356d0a5a146e595e6f01610aa4ef1bfe0914151aeeb603f395f03bb76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df89784a613bdc50d0df7fec329cb34f248d30be65d235094f56e94e02790b73"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end