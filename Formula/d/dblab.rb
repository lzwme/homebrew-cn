class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "8d968960312c4f258675a32c581a3cb10139938f59f78bb67b2cc2a57bbb37be"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81f308b0850256cf67dab9badbbe073a305772ac92ab75464cc5650c7239751c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4279fab7e568b5be98fef4dd7efb2e97b8c36317d7ddad60d9b14ee4122be4b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be3a12f0d2c63b85bfb71cf53c16363575cdcd85f355b42d3f17a693915d4408"
    sha256 cellar: :any_skip_relocation, sonoma:        "04cf96e8fe36f69b082094b0833e5b661ca0fa43ac6fadd9b3c88bcabf1c0c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "272afbb9cd72a556fbb07570c9b36474856be2245407ddaca0b368381019f3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d4597bdefb7824fc76791fc75b5af17dd8a3f53265be6380258eb946d147d48"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end