class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.34.2.tar.gz"
  sha256 "8d26675b486611dfa5ac93e0c4da9d73791eef25229cb813a6064d0fed0ea61e"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b19d5608afae1454afa13c9061649ed9e71f935fa10e85fe60a110ccd4332bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a42c918ae683fcd375bda62c9c07a0709d1c9a053eaef29e168aa80cb7062e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e0ab506cacef83268943a2b156887e7b875af499b461ea4af98900229524621"
    sha256 cellar: :any_skip_relocation, sonoma:        "2701ce92c930ea1e43c8a0742a27527623d047cffc956a6546fb2d9fbb1c6a0a"
    sha256 cellar: :any,                 arm64_linux:   "f9496b4276ee76826af1c98995d1ba1ed0231d8fbd3c667213b1d0125f425b29"
    sha256 cellar: :any,                 x86_64_linux:  "3d1562c526da170ea7d6bd2eac337295a9cb569cc7505b189a047081c25935f8"
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