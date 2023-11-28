class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.53.7.tar.gz"
  sha256 "3023475db64597c9906ac57344f7a5dbdc6a30920ce1a222400a4e9c272df331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "850498c73d7dadd4fbb34b1997e90018636a163aac920232e73e970e270c853f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bc236b89081026c826eca65d77011e8eea5339ba5a7f2e6a6dc7ea7013ab89e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "277a13047f57b7e1f96fefb184dd4e5f324d6ecf915f11d84532dd82d96ce969"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2d4bd22894664aecb8dfcdb0b90ea4f85d40ab34e282f42b781dd01abe1f00a"
    sha256 cellar: :any_skip_relocation, ventura:        "d916e8132554a153c292e0c4ac0196a6eed2486277f7e4b1b562728304b005d1"
    sha256 cellar: :any_skip_relocation, monterey:       "034c71d3e9a0387ed5756d139341cdf156b2ef1750f073bf7bed83b843b1cc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3837591d80efd06f9834506fe70cbdff1970d0d24a5d75c4a71c1d0f8897269b"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end