class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "606fcc3af794833b266c268fadbc20034995f1e151a57053fee082164a4ab28b"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e2c180d7841bf3320765ba65110ed5fc5fb79086f64394f5f50e3e0e26168bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b63200eb1fdcb37247f57945b20f1659a6c71aa32c377941fa1d07999a69b3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e7b289f74936aa382f962932711b51ad3644cc1ec1a3b493022ef5970848246"
    sha256 cellar: :any_skip_relocation, sonoma:        "b712b1fc69747ea98124adc404d421567c8cd72533e1e23f122d32598ec90bd7"
    sha256 cellar: :any,                 arm64_linux:   "7064e1871b7f52d45ee4a96b1306d19f6c09b121025c3b0823e520d3cacf03b8"
    sha256 cellar: :any,                 x86_64_linux:  "13aada98df6a4b1c00082ecd1a97d68a96bdd05a34e927840d65c8b55cc4438a"
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