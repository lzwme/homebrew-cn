class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "1d78fb82cfaa4c1282b7bc3d34759bf5cbee56bcf1a78f462c4a291aa5b9bcdc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a1b212a2583a7a8c536de61f1852b05fa7fc907775e1c11f0c4e3ecf00ec63c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44e653b99af7ab26932fc6d388e87b264c15d53494cefb33ae397fc0ef7de7e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88cceffb12522d6c027c812d835000b42534e217ef6c95593227d9e47742fb7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e84000b7ab92766e0ffad337e59960e553c02f0de6b62e19b0be5fe51ba65b5"
    sha256 cellar: :any_skip_relocation, ventura:        "7c3a23075c8afab13ae177d244a8d47f79d348be8fee9017630489e4a93a520b"
    sha256 cellar: :any_skip_relocation, monterey:       "05c82133923ccc5667dc380a705acfac9419cae1f32b1926f7ac1338ba77512b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da14bd350568b22e0d9e2fd8fc6c2244cdc69c79c8b29f1bcd035c83c6ad5aa"
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