class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.7.tar.gz"
  sha256 "5a859d449730307522233885390f07d6a473681960d490f50b63b21692b28799"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec21c4c4d4de904022de738b2bc5da6cd0254feb1e93a8b0720ca4a07a63397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec21c4c4d4de904022de738b2bc5da6cd0254feb1e93a8b0720ca4a07a63397"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eec21c4c4d4de904022de738b2bc5da6cd0254feb1e93a8b0720ca4a07a63397"
    sha256 cellar: :any_skip_relocation, sonoma:        "75e21b109d3a607a7ae6f425e9d9bc22b86ae414d31b75e024681a6959c99add"
    sha256 cellar: :any_skip_relocation, ventura:       "75e21b109d3a607a7ae6f425e9d9bc22b86ae414d31b75e024681a6959c99add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71e4e665f25e569bb788078e402ed43d07f4c447a450ddf5525458410657f29"
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