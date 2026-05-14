class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "5178e327fce1e8b4492025230c76908fa97b8e49452ee7b318769579455f87c4"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "719da56a14141c177301c163d331e552b7161f14aec3cb689b9bcb46d872f0d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3419d81c5841d8bd93e0f75ae87c0975f23653ec81192b0ac81e66af1ba9afc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fe2e7626d4c5b61de3fc89f4d9dcc74a0b6538c1f78446576903e04b4deef80"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8e7640289b55fa6eb70d8fe467f1a7273ac3924ffacbc974acb47881b13fd3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "977880d534e67a384bcd70473d5260888483c1972641f0cd921cc94cab3176ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "215edb1c584e7fe4721b1227138c8e0ed3bbf634fea78d3fb15c01f9336e8d9b"
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