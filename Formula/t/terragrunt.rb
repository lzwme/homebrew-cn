class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.55.4.tar.gz"
  sha256 "513ea0ec48373ab7f91387a65c9a88be8c532705e9ee5c2e35d8fbc4923e7891"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecbe9750e782919c5ac85dc84d0a60361b6f195a0cec520e16eeecc116b39bc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1c483084c34fba59eda11a4779486867ec53a0fbd2feee7a385f08d308f54d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fc3c55bd9895e35c80a765d6d67fe6f33d15a78d4812e3300f4e6ebcc75b0ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd1c408f36b71bd4ef7d46bbb11467cc38933e664609eca387e068085e40978c"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd457d4effa16b4f54244a6c5b8be392a273c05bd57be2163f99b8aa1aa25ed"
    sha256 cellar: :any_skip_relocation, monterey:       "a5fccaf80dc2260e7a95622ef8334f1031e55cdccf0df1ce22c6966042b1ca05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba3a75956e11f14ce449177c22e95b11110b6b3a984912045deb11a84fa59341"
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