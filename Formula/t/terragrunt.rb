class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.66.6.tar.gz"
  sha256 "00d4cd310484bd5851fe41e091cc0a883f8d22d41986e49c617c9172941e9d24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc49a51d52bbd1d8040d2ea2585091a55affaed6cfd8f98dd8cb777dc4f11e61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0c80c7f2df3b01b9ef386a3c0f29cc0b02e0147e24d2386f26122afd0aa2673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b30cdd0de8add19365df6a53de63066113e1b13fccb342a8eeba95269bff0353"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff0fc313a12381b4aa26afe7e829f53e364b65070991b68c844d2f44278554e4"
    sha256 cellar: :any_skip_relocation, ventura:        "cec22c39bd98922fc83ff2136aee9e8ef05c474eae30307f28ce8826abe9388d"
    sha256 cellar: :any_skip_relocation, monterey:       "db7ac9d8e839e7dd3b998112aef9d214c3c2aec2f453ac03aaae87afe904423a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4996480f86a65cea8377db770b286f4ab7ed8b9ca7da60786aad1eb9d5d00248"
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