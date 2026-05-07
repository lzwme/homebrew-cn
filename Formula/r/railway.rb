class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.47.1.tar.gz"
  sha256 "7815d4f99f21c88f73134bc0a6b08b7fcdad63e6443aad26ddd3b89ba9fe96cf"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f5c571a27b19e198052f74c2067c4afde2549210a29b5c4e6dba34c8ac98136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce759697f2a6aaa98fad2eea917990218a0268bb783dce1ae654e1220bb0ed45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04629a79362cf5d0d978b26f4fdcd114e5a2f5d5ce31259eced8ddc69b2b25c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f0d10d19714f392744ac8f183fa8fb3846d46c1680d4d712732041b60e6f118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7c49844e54acdf3b79e3174827391df9250ccacdf9122af42cf6abfb71e8ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec215d8f4617f10b92e186ece4b4fe9633fbb96d557592d7bd9543db5634d8f"
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