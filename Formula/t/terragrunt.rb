class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.0.tar.gz"
  sha256 "440c91c4446190f0f82d24b6837ac8cfd658a37f3f685ae0c769e93cc5e58023"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0612cb58385b3699212270112b0955d55a2568de8c2299e57ae10146073d112"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0612cb58385b3699212270112b0955d55a2568de8c2299e57ae10146073d112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0612cb58385b3699212270112b0955d55a2568de8c2299e57ae10146073d112"
    sha256 cellar: :any_skip_relocation, sonoma:         "f967168808c3f3038d052e778dc11985648b042550dd423de4429dfd559f6e6b"
    sha256 cellar: :any_skip_relocation, ventura:        "f967168808c3f3038d052e778dc11985648b042550dd423de4429dfd559f6e6b"
    sha256 cellar: :any_skip_relocation, monterey:       "f967168808c3f3038d052e778dc11985648b042550dd423de4429dfd559f6e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "762679939b9fcecc3df355373cfddfedf352297afeff5816788c6d1092753b02"
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