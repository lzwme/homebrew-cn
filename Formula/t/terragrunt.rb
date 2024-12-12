class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.69.10.tar.gz"
  sha256 "da2bf481834563053c9be25e670b414f5678b8a435e5e2c23b5a4ac6f32ee5c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6031ffb777e2bc58571eb2d75338c13c4e09edd5fc6ea5a47446c6de49f444c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6031ffb777e2bc58571eb2d75338c13c4e09edd5fc6ea5a47446c6de49f444c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6031ffb777e2bc58571eb2d75338c13c4e09edd5fc6ea5a47446c6de49f444c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "77af8c7969e7676be14338b61be2adbe0a7456c614439e3254fbb150027f6c91"
    sha256 cellar: :any_skip_relocation, ventura:       "77af8c7969e7676be14338b61be2adbe0a7456c614439e3254fbb150027f6c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30fe921a498869936e695b4d84235af28a22ebf4c16925616ca4bd68635ef9ac"
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