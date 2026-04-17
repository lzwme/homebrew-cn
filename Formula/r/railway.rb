class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.38.0.tar.gz"
  sha256 "d76cf40fcb597434ff5981ff2c8dea0a308307fd5fcac1c572f58971c78a0b07"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffd3182b96bb1fbd8b494c5c7ece8f6064a8b77177862090e5e5ac7f18ea5692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2e89f34a216428dc8047bee220bf4b2d8768b412eef3c522bdbb887914a53ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3f1ef0bc16dd96bae5f2c9a1bc35a8edbcf8fe60dbf866138b0b92625095952"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b2c1e7909b4dcc71dd267a051c98cfccf756edec6872a15a87e45a5122e591c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bf23709d6b9d45348c5b50772daa53818536ebc4badb9cc1f0bc78e8b6b5f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4deaee90a0479c3ce93357c306d8fa197c69e3e69229e36cc3ac5004e74c4e89"
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