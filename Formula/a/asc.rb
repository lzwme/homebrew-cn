class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.36.0.tar.gz"
  sha256 "c4bbcf5a229a5d878a084743cd46a2f7322c47d06ac7c6b2d9683d514df47fe3"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e130b2b6d18dccbc85e9b9267d981d251e4b2b89c7e72e7757af1874401a274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d138106b1b222de87cfd8e0f99b1837cabc04e5bc67cbc9008fb1c8d808d5ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3412e3013ebe1add5576e2c22676451078f22c08a3f02cea526ad88faddc742"
    sha256 cellar: :any_skip_relocation, sonoma:        "36835dd4a868f86d61f8d36b62762bd3bd6dbb5970adf8f5f7ba8e0848ed2f16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad697dabfd24455723b2212f14a42435d40c8e94401267e813acc1002db99a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e26cb1fa53bf96c5bf4cfb49c50a4d2c08aaa6bc527b5244565ec4805ea1c9b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end