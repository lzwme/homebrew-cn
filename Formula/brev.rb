class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.254.tar.gz"
  sha256 "bdceeec9b4a1fdf5ffe6fafcc24246b0cc37bda4f78dea85ed3231782dc2f649"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3a3856eccd5d5626ea9dd8f3a45138fc8446af1a5dfd6a68e6a3a3906b55963"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e8d8a6dbf8af6b9ecfc253fbdd5b670412c79316ba47e2f7d15c3d69689f6a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "357d76efa471636a04b7465492522d13d7bffa4508be9e847e0787b808cf7345"
    sha256 cellar: :any_skip_relocation, ventura:        "57e3e2c0fe0fda2b0b2aad8a1615576481d23881586a915a7f7f4690f9141145"
    sha256 cellar: :any_skip_relocation, monterey:       "19fd0628078416522e3ad0545b600e7587edfe36c170cef429c6f64de09a01e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "75eee6bb48f26aaf4e70245248a0245dad010f528f36d1a52bd3bd071dd799b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b3ee71860e127863632f7ed4f9866884cc6daaeec64d3832fdd3c96121a68a"
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