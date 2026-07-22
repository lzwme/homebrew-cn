class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.27.2.tar.gz"
  sha256 "4ea8241d9e9724656c606bfb5aa2cab6092908a5b64026b526eac54a7a4af6f3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b245223f0ebf30ef65aa221c8e76848dd96918b2d2313df8e6af3f1625096ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ebff5192019158872c95b4d7df495c9334310f57a41a3fcd950f3ca722a6f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2165eb1475af681ae849358fa0936b60baf1f79a6bcac95421f5b77506cf2d16"
    sha256 cellar: :any_skip_relocation, sonoma:        "507b289fb6607fd3dae7023cca6890c1e5add37d123095497e5e08f94945ca94"
    sha256 cellar: :any,                 arm64_linux:   "0591f719347a3cfaf6cc9ca7e91e3db30c34d8d18ab50ecae6827e81a48c5b54"
    sha256 cellar: :any,                 x86_64_linux:  "d8b2305656dc415d81f4bd3094b2a05bc6008a5fab890b24c89d311d2c2210b3"
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