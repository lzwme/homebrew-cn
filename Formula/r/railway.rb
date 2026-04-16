class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.37.3.tar.gz"
  sha256 "d05341cc40a3a23d77592ea490b4b228e46e50003defa0cbfe59e1ea44432925"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eb379c5baf9678f76c29798739d3287664c5aff1f078ae65e1ea30463b2d0a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21c77c4435edd1da3dd46ec64716b3f5e9a7fa2e1131cdb427ee110320b3659d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c932d0d1aeae753fb77d644560fe5fcda34390a4e6717d9728b29527bf1f18a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9deb9c70727aa17fe473d6ea17e7694239b3bf9c99288b418c80816b6b5817e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7043d42bfa4b5c75e544e90696655d9f7eedbac5f389e71256c385a50019145a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2efe66864513798646cd74077a7153505df75af023282b1ecaf8ef777c96f00"
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