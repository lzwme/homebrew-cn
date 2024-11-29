class QbittorrentCli < Formula
  desc "Command-line interface for qBittorrent written in Go"
  homepage "https:github.comludviglundgrenqbittorrent-cli"
  url "https:github.comludviglundgrenqbittorrent-cliarchiverefstagsv2.1.0.tar.gz"
  sha256 "2b78d5e8531aa54d0b01b801aea3b78da4a4932d65e4243cdf3209a68bb80777"
  license "MIT"
  head "https:github.comludviglundgrenqbittorrent-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acbbec6e2ae18a3836e948642a86dc2628fe23f31f41a647e22323d1d861fbdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acbbec6e2ae18a3836e948642a86dc2628fe23f31f41a647e22323d1d861fbdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acbbec6e2ae18a3836e948642a86dc2628fe23f31f41a647e22323d1d861fbdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c99c6f81ebf2ca5e2e6461cc14ea24791b636010f3b75333191fea42bbe4a5e3"
    sha256 cellar: :any_skip_relocation, ventura:       "c99c6f81ebf2ca5e2e6461cc14ea24791b636010f3b75333191fea42bbe4a5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba350b2338f39e81a126cf9dad5a827018a0f90288bea9144f873ba0677139a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"qbt"), ".cmdqbt"

    generate_completions_from_executable(bin"qbt", "completion")
  end

  test do
    port = free_port
    (testpath"config.qbt.toml").write <<~TOML
      [qbittorrent]
      addr = "http:127.0.0.1:#{port}"
    TOML

    output = shell_output("#{bin}qbt app version --config #{testpath}config.qbt.toml 2>&1", 1)
    assert_match "could not get app version", output

    assert_match version.to_s, shell_output("#{bin}qbt version")
  end
end