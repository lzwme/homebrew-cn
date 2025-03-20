class GitWho < Formula
  desc "Git blame for file trees"
  homepage "https:github.comsinclairtargetgit-who"
  url "https:github.comsinclairtargetgit-whoarchiverefstagsv0.6.tar.gz"
  sha256 "4d81d2bdbd3fb2a0f393feb76981e33b3d31aa49bf97b4c0a69bad148aa8fbc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a276471aae545231042e81995fe72045c42c24169e0497fb1cb9ae421dbdce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a276471aae545231042e81995fe72045c42c24169e0497fb1cb9ae421dbdce5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a276471aae545231042e81995fe72045c42c24169e0497fb1cb9ae421dbdce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f1affd17457651a4574c7d31ff6de062ab24ee4bb9c12f9787eca1d2bac4176"
    sha256 cellar: :any_skip_relocation, ventura:       "9f1affd17457651a4574c7d31ff6de062ab24ee4bb9c12f9787eca1d2bac4176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16499bcb1b77e62b67272f51eca2f57cfe0df8e596a9dce83c0e662193a1f81"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-who -version")

    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "git", "commit", "-m", "example"

    assert_match "example", shell_output("#{bin}git-who tree")
  end
end