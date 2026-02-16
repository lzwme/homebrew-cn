class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "ba7c736207df621b3ca0590842bcf0ef48c63be34d69608e44bfc01eb4a2f848"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75fde0db35a452daa1765e3d0edc450a2de73246341eb8e49dd7fb312e7a104c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca7b4d551ec1e0714d26b3250426c25606bb8ba1a05bf72923ab0122a225f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b54df731e5fc84e4aa52497d70f85db53a24f47efd0729ef49de2d82b923cf57"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dc976e271a1d2fc6ac83e80dc22383e386ca02b44bc2b68623caf627712a8c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c01f8164740e63ee752ac687aa60d03773fd08da9ff6cb6df60c601d186e497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a0682f1cdb50209357d2f493fe7daf8a9f0952f6d10dea0abd3f479cb43fb80"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end