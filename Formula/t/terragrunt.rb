class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.0.tar.gz"
  sha256 "0a69268860c85489b2059b7558c3da32a8331aa999e076c01ae0b56bbec4cd84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb8b93ae69d2c65fb6bdd9b4fe1140da563ed21d8738368b02714d5f7c5955f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb8b93ae69d2c65fb6bdd9b4fe1140da563ed21d8738368b02714d5f7c5955f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb8b93ae69d2c65fb6bdd9b4fe1140da563ed21d8738368b02714d5f7c5955f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eb9d09638da801fbe1ce0766cc3a4474f213c814fb303e0967453a188cf7d82"
    sha256 cellar: :any_skip_relocation, ventura:       "1eb9d09638da801fbe1ce0766cc3a4474f213c814fb303e0967453a188cf7d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7df48a42157ada3f86ccd7504e2da468b64e997f8c336c507f047a022e3fc36"
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