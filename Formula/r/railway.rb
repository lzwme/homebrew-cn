class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.24.0.tar.gz"
  sha256 "2a6516e3f3e0026f63b13826f93fbc818531750a3e49674c74e59813c5b207cd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8ddafcdb268cf101aeb3bb5c4b69d4a9a62c02ec7b8fbb83ff0f457aeaf9a11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1b099e9922ba57593a239b72f0d07050e90e5d6553838c9f3a15496e034886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27157bc133ba459b0cea2ca0eed1939fc53d26b71c089c4d01017869e7f765c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f6645cd80016bd62e092c441315f51516047890ccb29e6efa5e943d469d586"
    sha256 cellar: :any,                 arm64_linux:   "80f5bf5bb162083f7942183f5335c293e1256891674882aaafb7a57917d60eaa"
    sha256 cellar: :any,                 x86_64_linux:  "56d1a3936c4d5480a6437ff278a020c11e5465f9baa65c548714fd908f18c739"
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