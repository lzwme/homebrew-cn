class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.65.0.tar.gz"
  sha256 "d21b6d75bc56a0fce9040a6e5c81ab66eff3ff1830243fd3d4c6abb2665ce157"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdedb86a31373f15d33b6967a4cb6be731e1335e3f5447facd140858f41df5a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723e69db347f135fdff2216b748d60915d4bf69a29d3414ce1d3bffaa537445a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "279046b3170aa49b57349669357567c6a2d1097805b0b546cd81c149f14ad789"
    sha256 cellar: :any_skip_relocation, sonoma:        "68735e2bcb18081707338e05084139df4fbe6f36f3a6b0b9c424e96ec1f68c38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52792b8ff8015837c35ca667646513b0a6579088308650353915a397c3b9989e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a21a8c2376ce8afa9e4f9a7e6519e8bb2e33c0315a9376feac99a65b71375fe2"
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