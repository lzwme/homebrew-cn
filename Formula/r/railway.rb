class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.27.4.tar.gz"
  sha256 "3d6806c0040487339a73000b582fc57f8e70c4c189a4658f3d21c00cbbacbbdf"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d61ec80ce72a277138c337a3f6e56e9151107823f0b8f88bff8d84e26d6a44f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "410fec6d66dcdf7c54aa1b51b77fff290650d8d57aac877830107491fb7cd554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b988d017d1049772a849163403c5085a889c0e5d94e4571e93f64d832a43e2c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "40ce8de8793f2661a93d431e3d689f3533ac5d538eeaf28e7d5dfa827bd7d95c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3709a1792270b1a6196e0ae1f1e569d93872d787acfa0204ae77a84a61e42b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e32b995b3d3be7121301633d9c20096ad03e00771bf67118c31732ea13ec12e"
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