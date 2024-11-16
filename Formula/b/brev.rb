class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https:www.brev.dev"
  url "https:github.combrevdevbrev-cliarchiverefstagsv0.6.300.tar.gz"
  sha256 "91bdbea9a2572726d2cc2256db3905131d276692bd493f2ed1d6c5490cc34320"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "668b2b933635accd01486d27584b3375563de505c90a23fadbd070beebcf48a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "668b2b933635accd01486d27584b3375563de505c90a23fadbd070beebcf48a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "668b2b933635accd01486d27584b3375563de505c90a23fadbd070beebcf48a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "29dacd701c953cb9029a153df9b6fd311c258da4508ae54b28c6b0fd0852240a"
    sha256 cellar: :any_skip_relocation, ventura:       "29dacd701c953cb9029a153df9b6fd311c258da4508ae54b28c6b0fd0852240a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3adfedee4ba5810c7c6f5324b4a413c1b7edf8fd1315a1553d649ca0092c3ae"
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