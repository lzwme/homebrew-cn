class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.59.5.tar.gz"
  sha256 "bd9b378ca24181e14bc807405b42a38edef4367920adff2a129ef058a8baa4d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79978ba6b085afb8312639ee323a2b54e0cb39622fe4b22307f1016db78d877a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "324202e09920fdd2718e157ae303ef46e461ba54cf2216a45bf6376a9d0236dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deb8c482b791beb5f9066586469b422b03924d04f32d9de70dcb3d1d655f071e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca362ca22004a98e827b2671899d8a0d3b8b16eeecd15e1aed197b7fbbee493b"
    sha256 cellar: :any_skip_relocation, ventura:        "421b2c5c36531c1b9447436c8f98f8c858dcbcf07f798be3855f823baaa01b70"
    sha256 cellar: :any_skip_relocation, monterey:       "958bc7b69278463275819ab839a0371ab71c6dcd95a0eb9fd17bb6fb42a25c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b49a5cbed76b4a1ae279a773030a44abc15e8d9af0bfae59ab9930dafe1f7d"
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