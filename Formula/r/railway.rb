class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.20.0.tar.gz"
  sha256 "f014aa9756b50fa1a607cd1bba69cded9f2e3593d41b6063502617bb371ea7b1"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9ab05885613b80ebeb7a7fb35a77875ab388c395b5b78813dc8d6028c89d567"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0fa3ecedc5c58cac1a16c70fffccfa59e02343e9866775be5a141af1ec06f82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d1a12eb4d9bc8ee38c04536c0efbd9ad1a7f831ce5164be0d2889ca7d3df909"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eb2f9cb42935c3dfb410dc7e8882d0f60ed8c6e4a14f03c22e5b53a532f16f0"
    sha256 cellar: :any,                 arm64_linux:   "11b4c68c98d8cc375e233bf19697fb0075e7d20a67f6d13423e2691dd8cbae58"
    sha256 cellar: :any,                 x86_64_linux:  "70fc3e4037a914a3d4af0ba0bec3943d97c7036f1044074b6a4f89503da79a4f"
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