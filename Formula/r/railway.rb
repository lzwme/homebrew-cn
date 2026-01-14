class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.23.3.tar.gz"
  sha256 "b2e2a12619bb9bdf1889fc6034ab8a412c32fe1f23b29632c6ca831bd7010bdf"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40ba53fcab2a15262054c1aef3a50d1daa3864ad99391bcb2cf7710179e2ffc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "535fbd8c7bf8597d3edd55d19f8144f07f34ae22659c64823e5f5cd6bb1a59f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd41b8731f93023af645451e314d8d9675c21506c75891a811be8b702d743f9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "49d4206bcf92bb3c0305fdb6f27743e12bc407819777a7a07952bbf8451f77f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d09d7de095068317398f8aa88712dc93941586c36385d5ee726309924b01427e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a656d20f39768f301fa42c9e9c10b7ed3d3c17431fa2aef37fbc3289c9ca71c3"
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