class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.47.0.tar.gz"
  sha256 "47693d972841074fda335d7b40b6ef5b1bcce3570bf9be34092d99dc1bf5e2eb"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6446c780abd13dfeb29694544ed7a15d5a48708d198cfa4c3eaadf9431dda59c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da0bb7d37b41c62d343fe71faad9bb2f950f226b9c579c7bc0dda922df55786e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f2619b515e20b2ca2fd10bc97f318edd9d1db12366d3a985753a29617863596"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4ede38997d69d4a1b6d1673afe0fd8c1580925df2c10a510f729150cd2f8c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e85d9a59299a4d3d4a56cc744216caf1831e00e64cc149493a2da2651f9963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f518e61d20a439439a1e80d3e40a74b6ec8eae744070ad8a31f68edf99fa80"
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