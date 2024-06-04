class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.14.tar.gz"
  sha256 "59948ffd852ff96e8c3bae660cc9be6d96834073af57de96543ae0d984a37edc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9489a8feb4f3b0af9827e102322905cc0e617a0ba69f1af2232b13d6eb72039"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2caa76de11c72a143a1dc07ab79fe6d42c0d456ca73cc6c6727c93519821f001"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4065534df8ca0736309e48541db93895501244e4b0a07d386c9513af61637173"
    sha256 cellar: :any_skip_relocation, sonoma:         "72e7c61d0c980f49429f60fb8a6363d730cd8d1a884ba4154af24dd514f0e719"
    sha256 cellar: :any_skip_relocation, ventura:        "aa8b43dc869e679dbcd43032f16eae8eddf6d542d38a71f227cf800108343bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "536774f488ff3a5397830a4465b3707216b90304df6676b1792da62ec21343a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea29ab2422e99e1f126672086cc078018817136dfbce01afc0ce704442d86851"
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