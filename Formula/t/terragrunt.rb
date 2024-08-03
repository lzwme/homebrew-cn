class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.66.1.tar.gz"
  sha256 "a61c6233ffe4d4be41c9f27b6f9ce92ebebf5db9e6f9d8f32a6b45d841321de4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4292872e2b10327d79dd904d11692bb6daea6ba6f21e379e92f370902387eac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1221d493998b2bd6a90a377993005f1a98ee33b59023abea946e358c354ccb47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa6c15717ce1485a2a391854cc0d14c805913e21c77d6d922598c8818f71725"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f09ff0a638e58f7c0559b1e554d01bdc66fecf6156a9ab0a6cefd2bdfb493e6"
    sha256 cellar: :any_skip_relocation, ventura:        "a0cad3b7dfdc000f5c35586708e0747619852bc9443f65a3cffb06093fc58539"
    sha256 cellar: :any_skip_relocation, monterey:       "5e039cec8fbc703f4d6ec8cca7f5ea41415481a1ca758dd424bc94060347c633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "590e51abca81a4859e3e98d63865659230e1d5de46f9c5604b31b08c08fbdd93"
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