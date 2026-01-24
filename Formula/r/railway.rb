class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.27.0.tar.gz"
  sha256 "2be89640903ade1dfda79a3150da67a13153c7d043bf7385563967f8611fc424"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f9acf29eb645ac0ad0b93baf2452a12c57ba76b365e1b8529ca8026cd4a54a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a92cd47afbd9af409548bd75a7bd7507a29bc4d6945876c810d4cfa3f8db0d87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f7e4f8aff1bed75e2ca8d82d035b16b665cd3c3fc46ab4956ea952a5cd544b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "efd6f72ae5b19a98b2ca06e7f0989904c425962d5d98ba9c165bb6e1fae11726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aeea69bf16b61c74bda745a2432c1a40d572694d1353fa5013ced30b5458139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d64cd2d9f0d752c5a62066ad62a49d578de5553a261905f2c901b8b84ca8537f"
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