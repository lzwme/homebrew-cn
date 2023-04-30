class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.222.tar.gz"
  sha256 "0c5c81c61f2b2f96be824d2ac5cb03d034bb469deb39c1eb5173d69334d505f8"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38df75924ad07e7a84a11ee6b32fc80d893c008c319f15ae918f6457e7512d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c44ea14363fec470db50d2495352ea3d6efcdac9fda0cc94a4e989bcd3cb987a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1dc35553b316b0b0e4978b22da2635079dfd4c2a06711de23308cd21d819dc4"
    sha256 cellar: :any_skip_relocation, ventura:        "6da4aabd6e3efa76a6bbc7f18896eea6beee5daa15fbb190191f820ff941d97a"
    sha256 cellar: :any_skip_relocation, monterey:       "15ed5e40e8865140e8f68254c1771047f0618657367c83e445fcdf349840db63"
    sha256 cellar: :any_skip_relocation, big_sur:        "201f8e8d2c65971928f9ade752326c261683aa573cbdc26619413289f7f62e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbeb78c93c91e4b706724507ca45b36a5ceb60913948f9a54b6adf78a9b1c379"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end