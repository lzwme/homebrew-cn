class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.41.2.tar.gz"
  sha256 "a7f55a0136a7b34e2d391056d023937b4b4dd13e986961f3f5b00da45bef51f5"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00b0b5a03a21e49d4a052a1b8491561d69f9a397fb9a81054a552b8d2e3098de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5850653529791a951af35c1ec3d7ad31940bac0b1e6d9b029bf3377814edfe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c314512bc2a2df9b19939892437ec1aff2fbefc620f1ef7c3166022b342702d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e6ca79827f30edc21fed821b6d4d5e1fb21af9eb4f01834e796499c3db37d9e"
    sha256 cellar: :any,                 arm64_linux:   "4163fe33284a163acf19c8bfbafdde653201944efd29c51b0b6521b0924d15fd"
    sha256 cellar: :any,                 x86_64_linux:  "ab3ff932a99a47b05ce9b2dc016087f1d489f0116d1f314485e6b3d4a5f179a5"
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