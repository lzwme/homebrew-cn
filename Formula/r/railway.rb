class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.41.1.tar.gz"
  sha256 "2f0f659f3d37948deb0d7d3cff4ae5dc225f8ef5176f2a52b70379c097a04610"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1639fd8c367daa295663cb7717649fcf9eb987f888b731998a5be6388ab7467f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad6477e75066e8d7e85f268b386c71cccad9a6cb314236a192738c97d6d9c718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "453a4d4eaf4ca39d8155fe6edc3aea6298bad2802122268730da3905db4d4b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ca196dac35b5ea64023943e23d2ec2f55e9607fd6aea6f501b69f06e41c5258"
    sha256 cellar: :any,                 arm64_linux:   "429437856c97ea8d05c214e3389701ef52f9d123d4fc86bd6bd18893d140b7ea"
    sha256 cellar: :any,                 x86_64_linux:  "ef331930f5ba37e1ddcf5e6279fde2906253d3eefbb7d28509c0617940caedc5"
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