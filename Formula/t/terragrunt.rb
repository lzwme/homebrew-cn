class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.19.tar.gz"
  sha256 "72d9ef109b7fc3e561de67eb9132266697843593c9ff0065213f1b074c80bbdc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62f8032d7a436b38e2aff048c29805a98053460fa8395ea68f5d83bcbbde6141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6966fb33af03e3ccb98b0ef0e94d3b6717214e494cf8f925540ba7cf67b8bda3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36025bacb73a4966cd183fccb8ac6b51fbd4b92f5dc186f5780749357a90f30"
    sha256 cellar: :any_skip_relocation, sonoma:         "9124a584c5c4f372b6640ce8ba03e647e0a1ec3db9f47cb72e050f67e2f092ba"
    sha256 cellar: :any_skip_relocation, ventura:        "118963fc698e5d3884ae8fdff500555c748c303688de019da906ec8bfc99464a"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb0669cd3fd55b6438991567d27f55ec0bc90dd6fda699aadd86f71aeb1cccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1202fa0500691363f280fbe957dc27e3e5cd40894f602b51a94fc2ddaca4c10"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end