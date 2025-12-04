class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "3e16ea8d2d213036f19cb34c5d778d4e8d9d9bb9a92fd9138a61d507488f4ccf"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "815f59f73442d7eafd6f6322f1164776771b2619106d97ef0a1fdd4611ecd2af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fadbd411df69c855105782e9b0ffd656bca5d3f23836464f3cbb310ec047cd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bcbaa454c883b9f31c10f5f122cc8263a343825571ec05587a80227f32c78b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7df6421d668dc5ba8c4106d936abf3b29e1cdd9bcad02035baa880edac1f1aac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b21179984ed5cd3a71a230bfa92a759019d39c948432461980ab34059baaceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6936355baaaf8ee93917ae78ca3905a80879828a72f0770c4bfb244b683ae10e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end