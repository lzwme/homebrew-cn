class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.35.0.tar.gz"
  sha256 "3f6de3333ab809a010eb622cb1e0150d417c34caa3708ca529929c7537053d5d"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8615174bd0398f838d16de26d5315215e98550af27eec8bc259eb7a8f9ec7da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb60cc70fa448e0a76502e1e988880f206834d5b5fb8b30ed2e8090a7cc4802d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e9946306081bfd94860866c18575067331e96a3650e6b6b5b56007143355dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d3fcdcf9543be532f554a562aaed5f681fc4703e80b856936eb33a3616a71c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec8c15fbd9cf5c8cc616ffaa11a21f534b101ea78068d57a9977f2cdfd4f1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a75c366c476cbc1a14c4990757bd2ad471a80cc49e91ba6c7b0e878cbf1f747"
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