class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.75.9.tar.gz"
  sha256 "ae094fb7fd8e8b69dfc2d8432ed92ad0478a9e8f55df82931a9a30e5fd6e1036"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6329f25dd58eca8e5bb4c70ede7c4179cfce72f38b9e94f7c9cef855b64dfc46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6329f25dd58eca8e5bb4c70ede7c4179cfce72f38b9e94f7c9cef855b64dfc46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6329f25dd58eca8e5bb4c70ede7c4179cfce72f38b9e94f7c9cef855b64dfc46"
    sha256 cellar: :any_skip_relocation, sonoma:        "14517567495b7adc3defb61ba2a386827417d8446f8681af77c616e8d6cdcf84"
    sha256 cellar: :any_skip_relocation, ventura:       "14517567495b7adc3defb61ba2a386827417d8446f8681af77c616e8d6cdcf84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40c7cc7a8074c1b1b94c852db20945432477ca98eebeeacdfd9451a49e55785b"
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