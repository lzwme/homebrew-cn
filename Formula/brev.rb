class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.250.tar.gz"
  sha256 "ae4a5d347745179267dc8d079cea2342a21588a551cb23a3e899fe8d82fa1148"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cdbcfb5d0f810f7f68554d877a560c41ef22a24ff602013d7ddab725a98cc14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7d4804344350107133b42a5f0ae8601ec39d5ef73b12e39e221442a566f92be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25d92d45aadf3cc20be30cfeda41e8afc85a1906985e00afea70a3356b165260"
    sha256 cellar: :any_skip_relocation, ventura:        "9cfa54f29cabb420633c2848684832c659d6d1b3fd88cde0437573e6c1962f14"
    sha256 cellar: :any_skip_relocation, monterey:       "e2e7523553647e7f5fc4e0e425fffd96c448a835a6429f5885bf38232c17d274"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7c0de57c26a514c9c40ce259d2b28118739a393a8cf285a05c0316b476db438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14b3e4825d3d2e937beb4291787d1193d201a1aaaeb883a367026107d2f4ab80"
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