class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.35.1.tar.gz"
  sha256 "9fa89e7318e8bf767a925013cce119f0d9153e9a66442812e04d61ff89d020bc"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a779ac72003c1dc7879f37d2c65add445d86f04e18e010667552f79a1af53c9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a102ba0fd0ae1b359df2d8cb419f7b1d6bbd489f5be2d1c1f126712f7c5e3231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2271e766a144b9662ce2572dee89f7032048b6224888ec3b859914710a31f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d741c4ee3184400a9ddfb9dd0cc97ee9289fcea4f808874e0aba7a2317b7f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99b3390e8fa7914b9cbb92f0cda830f25ae01803616ee4ffc9327f49c26633a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b072285254c7d4584a4efd1579d44e14f50702cf1eb1e50edfada132f9152c4f"
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