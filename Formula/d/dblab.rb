class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "cc81b0a40ae1fb15b2a8fd4f7a4afbfa9e20c2ec9ddb1ef1a06afb23f0b9f855"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a869f498c086cbd2707dd071d8c44a0870bc1276412910fede8adbda55eb68a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5338d4a9dd03d951c63411c20fa6c9bebda4f58236fe236d2ceff26509b1353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93563ccce38feb1f4bc1d8fba48149c695f891f86bcc34b0f192dd5c213c8e62"
    sha256 cellar: :any_skip_relocation, sonoma:        "b72f0e73628204f782f56c691d5edf35a63fa9747bf6ffa7e7b96445b23af2d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18d016da95f6f796f7b22507f49e9dd4a2b04d9ad7afc67681c0d01092d97fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a798b71ae5ff70b5681e595bd0e5af4403b29f26bcddb84c087a5625c16f377"
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