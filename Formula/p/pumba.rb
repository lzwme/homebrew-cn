class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/1.4.0.tar.gz"
  sha256 "74f2b50eb62d83ba33ae0a8d6308c44e65a7080f1f5dea46e247f163a48ea393"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d7529684b63728b372dfeadf897a91ab1aa23b208edeeae6f04f91d740d9c32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d7529684b63728b372dfeadf897a91ab1aa23b208edeeae6f04f91d740d9c32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d7529684b63728b372dfeadf897a91ab1aa23b208edeeae6f04f91d740d9c32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f1185dcd53967d1673498d2afe721b0cd1e3294c90617098ec818a217979763d"
    sha256 cellar: :any,                 x86_64_linux:      "b051e57932e1846dc09376941ade86e973a80411bc8a955c4cb21ab1bfd69462"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end