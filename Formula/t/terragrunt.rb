class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.10.tar.gz"
  sha256 "b5f4bcd5ced56d6007deb04f66093da2f2bdebb27fa85ba8e8cf404b0963df8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99c211aab9950e15cc1aef20b4891d4370795827aa5b81ec779a1e3b2ca84c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99c211aab9950e15cc1aef20b4891d4370795827aa5b81ec779a1e3b2ca84c70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99c211aab9950e15cc1aef20b4891d4370795827aa5b81ec779a1e3b2ca84c70"
    sha256 cellar: :any_skip_relocation, sonoma:        "4552eaa938e5c27519de806235479425ee5974a10b7a2bb336943a561193707f"
    sha256 cellar: :any_skip_relocation, ventura:       "4552eaa938e5c27519de806235479425ee5974a10b7a2bb336943a561193707f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb3f3cc2923f5dc131defddfc271512c5fbd0049b7dd6d635d0c6edc9b1a552"
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