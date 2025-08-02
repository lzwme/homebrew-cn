class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "efed449e2d40a8fae88f206f2d037f847c4941e56c0639009696a5a7e4db1272"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc7c00be7ff5b8b9a4847f1ba54e0599b3ca7da4f179097254296bd72ab7f915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8c3e76faab6723765e21639136edda983f5ceb2c9999f2374ee2fedfe46a4d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd1acfb47357d8088ed05e942849f50d8d4c7b4c178a4f096c81f5fc01908cde"
    sha256 cellar: :any_skip_relocation, sonoma:        "f306e8d0a3cc17275ad924e91b28288d098af65c89e46d2a6571b2855ab3a5af"
    sha256 cellar: :any_skip_relocation, ventura:       "a58435dca576004299f2343cbd69d8af63110e3b02fcd9d316de2a59166f54f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcd5a4413c387127614039470a961e98bbc1f4e004bf7c122ac87f2d44e391cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4407ed2ef0f34e284a0b3beb4617ab2d72f37a2925c24c94875f08c520078a"
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