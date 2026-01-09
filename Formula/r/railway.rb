class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.23.0.tar.gz"
  sha256 "1cedab3257d2883d22ff79c923d07ff8bfd6e1bc400b30a3c2e4c913ff5544d0"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f18812698dbc9899ebe0851a01c320e572af073c0ec6d30483a8c6699e51051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc56bc2d933bf0564514070028cfcef6ceb0c2759b52a8f27400a55887f63410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b98feb368c3b5d0bc6efde2ac22e2f234f00c9ffb57aacf25c04eb76fdb0930a"
    sha256 cellar: :any_skip_relocation, sonoma:        "32650f0d83550ffedbfab90f63676072351565b644044140f417c195d1c5ae93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1305146c0f675c81e42688f9791b6ed9c1e0d3bf7ab76a3aca0319f36855044a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7565b77646ec835983f420ab0c20385f762cb8380602a2b99348fa23fcdd602"
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