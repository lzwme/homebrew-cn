class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "b7ac081fcd6628efe8c5fb5f76fffc0064cfa6c72ff0f342eaddb871eab91fd6"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1cb0190edc00e5990ce3b4769851e6ae4967227dcf81004edc1186e7e23c913"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48dd973e86723e585b3b4756771b0ff4e73be747a22f6bc176176ef1f54e14bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620a8b758f564638aadb37b0366a2406b4739eaeaf2088f600a2dbf29f49b09d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c46ff160d3e3f7e159af08be2a9fe7db9ea56e03765b7d94c0a938ca4081fb7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e562cada2e0a82f22533ccd7d4826698c27a5bb8f67b12d85cc6ddf51e09a2f"
    sha256 cellar: :any,                 x86_64_linux:  "e469a20bf214c2215b5bc14fe283882d77f5decb12f3a66a54f3d4ca457e0ff3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end