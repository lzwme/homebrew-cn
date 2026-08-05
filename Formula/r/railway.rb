class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.31.0.tar.gz"
  sha256 "5d2ddab41da248f73517867bc4a89334bb4dd2cef2b7459783cd2610e54fdf98"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee4a42cf96b1615326c53a5522097c56e60f76733226d1860e821be58b0d4fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdabfd19443674da8f97339ca023ccf0e7cf1435aeead1f02c346b5eb5c982fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bd9b9ff5592bca28ce2f377ba4d7cc7c8bda915aa899b8ca11a01ead826455b"
    sha256 cellar: :any_skip_relocation, sonoma:        "51827766eefc8498d7a200fb1db388e7935ab77818df85d497f407cd8eeab89e"
    sha256 cellar: :any,                 arm64_linux:   "174d33c3d90b266a3f5b2181117cd15d5afe8a8d347ae4fe4603717575629957"
    sha256 cellar: :any,                 x86_64_linux:  "f7d11389b93342d6c01489a81eb96772de8f98d21c97c3a3f06e41056463248c"
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