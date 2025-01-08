class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.71.2.tar.gz"
  sha256 "2adbb5681cd3d1b0640dfbb1073f2413ed53831b0db1881bb4409a769fd3366e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa81aa95b2ffb170547d2eba0bbf01f6ee0ca13f55e57b99cbd5e20916d38960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa81aa95b2ffb170547d2eba0bbf01f6ee0ca13f55e57b99cbd5e20916d38960"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa81aa95b2ffb170547d2eba0bbf01f6ee0ca13f55e57b99cbd5e20916d38960"
    sha256 cellar: :any_skip_relocation, sonoma:        "a04a6eb770d85a012dc90e2b345a1ddcd229c34af555670d3f2069b574eeb5d1"
    sha256 cellar: :any_skip_relocation, ventura:       "a04a6eb770d85a012dc90e2b345a1ddcd229c34af555670d3f2069b574eeb5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11c0d556b379d0843fa4ee1e2001a6b1b07d54cfe919469e8f5814c583c053ff"
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