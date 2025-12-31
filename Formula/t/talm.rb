class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "73243a88f7e15dc9a1bef8703edc1d040fa83402022ff6aa6e46c6ddd8804a86"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a578944e0881e5982abbe68123037614bd9d20c697bd1329872e691012f1f070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "034fa5be19f07b337cbe30007aeb9560023d1f6e345c4bdccdcc6639b3910138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7432c399dd07c524ccc59ba9692c7bc23cb0186df07d435c4144aac9482e412e"
    sha256 cellar: :any_skip_relocation, sonoma:        "31ce6bcede7c5088917139999ab7fbaf71968ec65c340b2cb891e95715b9c05e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e880afe6f3c7e98a26aef9f352867d16fbb03545f10975d9465d5cd7af05a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a131cc7a543da586d58619da87ade4389846eceb31af02885e35fa9b908fcc5a"
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