class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.27.0.tar.gz"
  sha256 "18e2a0f4d80196c4b77f42143219eb16b366ca17a146fe57c74386c051369e5c"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19070cb9892512eba17f06daf07c838d20f5315bb58ea787f9eb3edf013a49dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a8931e6b8fe4bc83b59b29693684850dddccf6f1fc4417978167bd93222bfa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e5861c04409aeeedebaea1802375600f2e52b3261c7ed6d7f0c07db5d6f1b41"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c2b19a55b9211524b9de4ee4ab7104aeef14760b88978ba234438313ad7de8e"
    sha256 cellar: :any,                 arm64_linux:   "da7c95a7f51e2cb39fe18f56bc2533cb62f13351fd5bded3da4ef393783cb790"
    sha256 cellar: :any,                 x86_64_linux:  "08459b51e9cc88008aa0a1fa56384c7e2cacfbbe28b4fef23d5d2711493ab00f"
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