class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https:logdy.dev"
  url "https:github.comlogdyhqlogdy-corearchiverefstagsv0.13.1.tar.gz"
  sha256 "aaa5b05b13c52d58ea840c4e54b86315df516b8f0131145379040311ea8117f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a68c4abfb604f793b9073993c79242aa020a479e8bbe1f36fc758189163d4c76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68c4abfb604f793b9073993c79242aa020a479e8bbe1f36fc758189163d4c76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a68c4abfb604f793b9073993c79242aa020a479e8bbe1f36fc758189163d4c76"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fa1aadfd4b1f56d083b44cbcb9e82aaa78ea18e3773d1dce93f0d0b0879c2e7"
    sha256 cellar: :any_skip_relocation, ventura:       "4fa1aadfd4b1f56d083b44cbcb9e82aaa78ea18e3773d1dce93f0d0b0879c2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69f015fc0b94b74132eb8d846a33fefc6d207e4f902eb27f7d9b0d1b22431994"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}logdy stdin --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end