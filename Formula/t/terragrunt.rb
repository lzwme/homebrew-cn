class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.56.2.tar.gz"
  sha256 "24ba70749202887a3ea309ac3da9e31cc67efa37a0ff946cbb362d44fc840309"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fd5b50d04a918f8b58200d2cdcb229c8bf5641a6cff65ba530d88d1b9817178"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21d19cc7939ba569376103ea91df6cc5f529bbd9d5295ca97cc4043cad6232cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c10d2cf39ccde181772284df222c705f9a04b523273771ea8e1e748e0f7af29"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1312e68b1171f5fa3b5fd0993ec61fa43e8fc0fb601c63fc6be149dd709e435"
    sha256 cellar: :any_skip_relocation, ventura:        "71ed7c851a9d65ccb5f9b29df1552520cf7f7b7143a27de39a9c8a3ec733ae30"
    sha256 cellar: :any_skip_relocation, monterey:       "96183c3d08aa95d8d12cb3afdadbc2cf3df0af20854ed4428dc10ed2af486831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86db297f4cd6a9d686d887f165eb07c333692c7f2a741ae442d37a71f78a14bb"
  end

  depends_on "go" => :build

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