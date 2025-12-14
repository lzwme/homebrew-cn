class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.15.0.tar.gz"
  sha256 "c6ca766709c6e2e8c074d20fa1734ed764fd759f77af5a31eab944eb3a6a72aa"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42f1c43c0aa796299cd39ac3b05d0d6a78e18480fa5b68b705e34883031a2a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "882b01f7b67c73cff4c270188d11afec17777efa798ed07e41f9bcd6219a4eb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e25c7c23f5d511121673c6084cee8c0f535dbdc134bfe100b669781fdb8e58a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7b244ab4946b537d0023d17fe24d4f990dda835a25bcf3f714c544fba770766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ded3a9100ff4ae60b4cd7dda9292cd13976563b6eed2cbad186a4fec2eb1682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7960a2c941dfa27ed7e86d1fcfeb8faedcf767ab5e68cc71a34440648532b544"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end