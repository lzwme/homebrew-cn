class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.10.tar.gz"
  sha256 "98157bdb7fbe3fbd5e9d1f761556ceaccec02d60f0b502751710ea640f4b0005"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbe8189fbbd600c6fa807a77cfb5d5c34500702da1e36381927095f30a79b876"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59247a4970911d5fa178a8d9da55c810c27500e1e3dc818400078147829f30da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1299420da91d360ac83189cc30543da8b736ed3409cf8821bdde5d717daf72"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa950362b75a4ce248e0866882d1b88e6da8247d02666a399590a96889aaee36"
    sha256 cellar: :any_skip_relocation, ventura:        "d33328fed8c2bedc4d70fb4d1bc3a27f82e99b12f952eee482f999b54b2003db"
    sha256 cellar: :any_skip_relocation, monterey:       "e03c0ba2c6eb0fd5208426169a6f06b3c456fa5a105e52ae8f200667f62bc79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8620312c1a81d6757f1022f1c7cc57d90f8727f876315840a3f5c01411efc749"
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