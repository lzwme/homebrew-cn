class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.45.10.tar.gz"
  sha256 "86b10a39fb776e86ac852b6531abb2e35b3629d14c7b98d17a1d3a66ec7632a7"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b7e7ea2f090e06ed1b938541a7f36b51d617d667cc1c461bc9cf117acc8c5d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ae2e9ce74c4edae77c29f8562b0d68f6546e2f47af184b64fa68c7aa755167b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3d87643cbab03296c3d318fc0a55ef83fffd9e46eba3ed57e14148990e8dbd1"
    sha256 cellar: :any,                 arm64_linux:   "b96028aded7bb1e33cad8034b21653edd19e1a43710099def1f039161ef5358d"
    sha256 cellar: :any,                 x86_64_linux:  "2137a445c5d289a7f8c459d8fa524e75a67674db8c3ab18740c3f945e731db48"
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