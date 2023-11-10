class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://ghproxy.com/https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "6e2985140640f06417a9e40959964b4a66a2b1a517575fec74456e10a81bb4de"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dec329001c7c6f198a472995c3fb27a3f0efe469158a5710b89646e17868e740"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "645c437ecd591cc4379e925d214ba54b417f5ecac080d19519ea4705a97e39ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4878e5a9f1ad05fe2ae185d0474984951b9b0b1cb8663ce871ff1e60549bb5f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d7b1af59e9fa2590536a364fbc0c488d0cec6083563fbb30393600dc95d4ac7"
    sha256 cellar: :any_skip_relocation, ventura:        "3a4f0ba2c60ee08d410a5cf6b922fff84b36f4e9e0ccf0f3986824b924d057e5"
    sha256 cellar: :any_skip_relocation, monterey:       "421ce24ba55f2a3a39c7b96d7eb6997452c2ca94c7612d7e1a53244fa9351cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6802ded6c13cdb01a45dd8c7c07285a920de86e33960aec0cdecac37fe5d63b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "Error: you must provide the Woodpecker server address", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end