class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https:www.brev.dev"
  url "https:github.combrevdevbrev-cliarchiverefstagsv0.6.301.tar.gz"
  sha256 "6b843ec4f929f589b812340162a9c147435d5c1601a914ae0e30b4c3729a49c8"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eefdaf2b0f4b83f445d64bab8457f33cc66cb8f09d5f55050c7c0085665b015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eefdaf2b0f4b83f445d64bab8457f33cc66cb8f09d5f55050c7c0085665b015"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0eefdaf2b0f4b83f445d64bab8457f33cc66cb8f09d5f55050c7c0085665b015"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb46079189ae9955280f0c92011b7bfaedab6252ef12cc7930316b8068c010c8"
    sha256 cellar: :any_skip_relocation, ventura:       "fb46079189ae9955280f0c92011b7bfaedab6252ef12cc7930316b8068c010c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "259b4fee24330a5f9127cf6e1ba1435a6253a26d33937837e30683e4e357d96a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combrevdevbrev-clipkgcmdversion.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"brev", "completion")
  end

  test do
    system bin"brev", "healthcheck"
  end
end