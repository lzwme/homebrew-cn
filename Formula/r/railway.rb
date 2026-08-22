class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.43.1.tar.gz"
  sha256 "f6a1cbc6b59979cb2a01d2c8b4741b777f74a20dc8c854825dfce0781c30f9af"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22173adff9e9ec22fd0a874ed4a2672bb83e7a3da1ca2ee93fa890aba0d38bf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2ae8c05e7bcde76b23719b36fc049f1b4365a58dfaf601c1fa8fb74abb54f44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bb931e755d829d40d3278489d6485bd9b6d75ba63dccd73fa783129d1973aa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ed422b7f2ce10f933da07391e88e1246799075182a224321511d3ef6435be91"
    sha256 cellar: :any,                 arm64_linux:   "c43584b0b59444a05421aebffe7d26262cb2d14425083183fca9cd12bbcc3698"
    sha256 cellar: :any,                 x86_64_linux:  "d66b95762cb5ad4c5dd3c3aee016ef3606a3356f7742b3c149e59856591d0a0f"
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