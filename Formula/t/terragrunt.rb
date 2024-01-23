class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.21.tar.gz"
  sha256 "580de729086ffd700fc1c3e6fc11d50d9998435f658522200f539d61a96943b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ef2478756f915e00bb3464e384e3afb7ee5998057104530962537fc5121d837"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65fd2fb479382c5bd67f981307c1a747df0ad7f8f48aae3eacab2436b813acd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "772ab54fb7faf46b8bdb22d0797e49a65b3e7aaf84f7b03a26af6889446bc14b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2675b1ec268bb434e4c1e4feb6c220c69fc50b4b14a92b987a04738d9d6ac91"
    sha256 cellar: :any_skip_relocation, ventura:        "fbec57a8a168aec67e088efe8a9e0059b2d33ec9205b83ff943a13bda6218217"
    sha256 cellar: :any_skip_relocation, monterey:       "c072d3cc332db3ba8b29c6a0916563fdac56b280344b8ff48d29ac56c122659a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda54a4c5465c2d7741e20168efafcfe45999843ae27436fda2590f018f2111c"
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