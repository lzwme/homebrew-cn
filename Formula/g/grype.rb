class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.74.3.tar.gz"
  sha256 "af1016bd298e289a1af5b1d152041a2fad68c3b4ada32ba3401339dcc237e13e"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "750028bf1625ac94aefa84ab3c45b96f626f54ce839327e665230eb655437eda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f7fd667aeaad1c99c1b3aee7a8c995e6bb1b1f6d8237ab1ab5c3aa76c1612c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44f31856085b93784ae37c2d63bf1255689e85245397f2967ee5f3ae19d0463f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a8af80919400a9014cc327b318d391b818f1d51e4ea8a2bbaba9681bd25bfce"
    sha256 cellar: :any_skip_relocation, ventura:        "c89f4cb42b0567df0c23d202820d49089ea15a87a3d15308706ca189389ff42e"
    sha256 cellar: :any_skip_relocation, monterey:       "cd394ab2da3318a3571329a166c72da5a1d4300d1199af852b0366ff08f68fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b60fa50876cf073bb9c17df799c2dc60303b4bcf565e00210111580ed998c1ce"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version")
  end
end