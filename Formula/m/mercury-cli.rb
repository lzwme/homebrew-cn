class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://ghfast.top/https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "e9c367b8c95a79745ece5ea285b8986b89dd3fcc572e11f3f7cdaad8b0077152"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0842f207b61c2951edd520d1f2f3be144eb5c52aa2106d16f5ad9042a89cc3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0842f207b61c2951edd520d1f2f3be144eb5c52aa2106d16f5ad9042a89cc3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0842f207b61c2951edd520d1f2f3be144eb5c52aa2106d16f5ad9042a89cc3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d672381c7d776f33aa18756b04113a2a016f57468e3715ae5630e3c7b0481227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f7daed2176f671f54d9772ddefdf9f862947eae8472a0bfeb900806f74d5f1b"
    sha256 cellar: :any,                 x86_64_linux:  "701a8a01d23b7e7293e6f4164d8dd62312e4bef008196013c1e8e68a8a48cc1a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end