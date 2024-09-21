class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.10.tar.gz"
  sha256 "576d386cf7a0a20a4a9883d51ff2b4727ca0ad1d7c16ca1838df08f5c6943489"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2ebcb298212a763b7b530e45045aad712dbe238470802ed980d8f3f44f7b462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ebcb298212a763b7b530e45045aad712dbe238470802ed980d8f3f44f7b462"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2ebcb298212a763b7b530e45045aad712dbe238470802ed980d8f3f44f7b462"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0cdd6de9acfc0b354aa81d035e3248eb8dc6777f36bb462c10d8305bb9f7a46"
    sha256 cellar: :any_skip_relocation, ventura:       "b0cdd6de9acfc0b354aa81d035e3248eb8dc6777f36bb462c10d8305bb9f7a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef989ece3d151f6606ebfa9d632993b92f3f72d62b10bdd3e9dcb1a43f3d3f5b"
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