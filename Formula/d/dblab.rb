class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "175633c9f7fab2b58dca4207b094c93c30162b09b53909a96dbcd679d0bb6889"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ad2bd96d3188b43f14e5af5c3cdaa9e36c70a41e225c18de12c3c5859c4f291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0da348bcead672b02ae4fcbea058d8d7111dbbe75e65594df4efa1eacbe4e8e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf94755d622cb6e4abf05d7a3d0514b101410479bb7ad3f9dbae98606b98531c"
    sha256 cellar: :any_skip_relocation, sonoma:        "adb48660d236cf0cc4fea1b56a68fd835ad8554082b1c7aa76ca6385c4c5aca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90eb87bbbd6a8bfa9a1a2e3e164b072f831bb7d7cdea4fb49787d6d233251782"
    sha256 cellar: :any,                 x86_64_linux:  "dee7dfde0b8f7816eea9be6925eec320d9eb388592041f0110a7c20d0940a559"
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