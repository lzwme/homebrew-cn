class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.57.2.tar.gz"
  sha256 "0754f19c9c6d4534b940404e8b28cce9270fc6938877079eaeb160c51250de29"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "069b77fffae57ada12c42f30e427bc0027eefb00b9cafce168cf4def3584b17e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8bcf8b8dde357d78e8f72d2f3ed6248d24fb6cbc73fee1bcc1f4adc2536e4e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80a44330029a652b0b1aeeb4134d23a6da854dddc1c4d3ed5200a6712e16102"
    sha256 cellar: :any_skip_relocation, sonoma:        "c432ab0b28a4642aaf294f8ae2ecacfba89043fb7e0b87fbaf686e435d57cb59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89decefa49dbbe50ae977d3fda913b15c58ceab152e219446ceefed021770ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b54b32344f3434fbef7559da3c5f06927b60023552a474fb519f4178ec61cc"
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