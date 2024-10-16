class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.2.tar.gz"
  sha256 "9de4b13d9caa904c0343c85429bb3c0c927fb1bbaa43bda93ad84890b06d1f1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "609091d823d9bef206fa4b1c130c543ac917e389c0bf79bfcfb5d0e22b97f602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "609091d823d9bef206fa4b1c130c543ac917e389c0bf79bfcfb5d0e22b97f602"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "609091d823d9bef206fa4b1c130c543ac917e389c0bf79bfcfb5d0e22b97f602"
    sha256 cellar: :any_skip_relocation, sonoma:        "964ae824f197f9d8212be87391fd8e7c26882f1fffac63dd65a22ad60a02c562"
    sha256 cellar: :any_skip_relocation, ventura:       "964ae824f197f9d8212be87391fd8e7c26882f1fffac63dd65a22ad60a02c562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9487ac07f9303919522ec9d49b5aa9dad7c0503c5edec356da1ea82f2dc33497"
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