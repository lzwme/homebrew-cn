class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.9.tar.gz"
  sha256 "891402a63c81be699e667c483a413528a6e7328bbd3ad36787f52b24909ecab0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b38a7dae80648129306a6b0b2be91ed19d88871efcd026a0df6354ae21ea23bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b38a7dae80648129306a6b0b2be91ed19d88871efcd026a0df6354ae21ea23bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b38a7dae80648129306a6b0b2be91ed19d88871efcd026a0df6354ae21ea23bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6a9e8da0598141d65ab7f23881469bf1a190cee5ea9acaaf9124e71b81124e9"
    sha256 cellar: :any_skip_relocation, ventura:       "d6a9e8da0598141d65ab7f23881469bf1a190cee5ea9acaaf9124e71b81124e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e6b63c927fe76573b736fbc64ebffec8d26ede5ba7b9321d9726ad17b4c227"
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