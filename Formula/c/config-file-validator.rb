class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://ghfast.top/https://github.com/Boeing/config-file-validator/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "e7c50fded0e036ef56d2479a2fee1eba35ea7fd232a4ba7c98ab087e4ae521ed"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00d8fa20356bcbc53c4ef85a293cb05510901e713d8f33d3f4c5f260afc8551e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00d8fa20356bcbc53c4ef85a293cb05510901e713d8f33d3f4c5f260afc8551e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d8fa20356bcbc53c4ef85a293cb05510901e713d8f33d3f4c5f260afc8551e"
    sha256 cellar: :any_skip_relocation, sonoma:        "84aaa61b1cc799fe5cee90dab4f458f5630912e27e5d1209f7232f49d9082afb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "931710a4e774c8dc61d225089715b7bedfff3086713b09c1251eb1e8b612b5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bcb1d4be243ae3e6606946650aec179de717df9e26654867e850993f66fbc2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Boeing/config-file-validator.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"validator"), "./cmd/validator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/validator -version")

    test_file = testpath/"test.json"
    test_file.write('{"valid": "json"}')
    assert_match "✓ #{test_file}", shell_output("#{bin}/validator #{test_file}")
  end
end