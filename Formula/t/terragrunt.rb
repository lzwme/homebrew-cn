class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.11.tar.gz"
  sha256 "37071d638fc7cd00bea53963e5035036b34948a693afaf45ac07e1884b84f112"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c16a249d7ea541b214e4f1b46a3ccd7081390df69d93e9cfc781f10729cccba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a603fbc269d5034fe207e76d6ef45ca5353770210227df939f7da63a8747bac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ab7bc3012d72c79947c173df022f57306554df9698483f1bdfdb2482329e784"
    sha256 cellar: :any_skip_relocation, sonoma:         "f137c8655d5dfbedf49cb0fb61bd4a79bd5aefd3781baeb1546b001259b9dc65"
    sha256 cellar: :any_skip_relocation, ventura:        "1a9760d04ac42bd285dd1a6b4dbab2b6eef35d8b1ea482bb2c9721d674d10349"
    sha256 cellar: :any_skip_relocation, monterey:       "c26ee01b053251da48d9a907dbed8366e73ce977684040562ac4a6087484edcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bce34f9e9d6bdb16ac73d809fc8b997bc226641ccfdacb6ee8d3b32e59efc0c"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end