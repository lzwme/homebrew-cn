class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.62.2.tar.gz"
  sha256 "e33a80ab59b467d61d4b2832cf189867c16f26fe1e5db1a7450578dde8ce2071"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3be57652a7b885b654af855e15f87fbf513592dce821efbffe57596a493af0d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a58f9fecdc50d84ed8c9515ea6f7881d12ba6af372a35aaf7fe88b987f38347"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66790b82886aa404228bb1d82d2a435e2e036732887f10a5d51ec1b83588b0ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "053f7dd08ad675059201479af318814baa3467b3f8b33074f2f972cf90506a1a"
    sha256 cellar: :any_skip_relocation, ventura:        "df4fc6daa4a7f8fd298eb4a560690cef641c7e9296a1bc5e76c5a9726873155d"
    sha256 cellar: :any_skip_relocation, monterey:       "b4375ef4396cde84b8b605625132aa464a4cd0ba0c392e92e76a10eb0db9870d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0da1af033e19826b90d01de08d630715a31f3cbeba8ba6019da6718b4cea72f3"
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