class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://ghfast.top/https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.24.tar.gz"
  sha256 "fbc7cb7665a7286f3f79455652ae45e97be5f17fa398bc240d9090ebdf31fd21"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09224b62375fe4b4e4b3b9c7e89f965229e4299ec7a35a2ed4de745627a86acc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1154eea14e5102d46d4ae20778641bf433ca15fda3ae409d46fd44b965fb0a55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae0c9cc662c36bf4994523e3ab3a7132efeb4ef9e5832c65a9a6846126ba269d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b838507fec19554422fe34e5bc313f685ed7209676b39ab3e63072295b613af4"
    sha256 cellar: :any_skip_relocation, ventura:       "ca22912eadf73d7f1a916cd6b0f5e475e5984094fab0d72f2fbed1d8584cc2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2e3d15396184172805786b5176a38e5c35a9a44cfd15787757e03abff169f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "107c2bf2c831c86b97afe942f398bde9d2dfe17d6c4fecbbda6ab983fa9d00e9"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end