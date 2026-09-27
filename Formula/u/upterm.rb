class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "ec824c90eafb7e1c4d068039004481e0d6ca17e0e35c45d2efb5a471f4177966"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b4b39c02f52c063525620592fb17206e6121afa91ab9526e9ed74568fbc3f7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e9151bcfee3a25a63917bdbf753b6a15645bae124ec6571048088bbcaa78469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4611fe51328206011731cd236639ca5a97eb7a3975153032a4be2642a24c0e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66fadc9c353d744366b712dd7bf499f0080599d01440d783e3a864d0d9d69829"
    sha256 cellar: :any,                 x86_64_linux:      "9c4dd7b90af0ff935323748e110ba14b00d5a6477213251dc35ff3eeb19c874d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/owenthereal/upterm/internal/version.Version=#{version}
      -X github.com/owenthereal/upterm/internal/version.Date=#{time.iso8601}
    ]

    %w[upterm uptermd].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags:), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upterm version")
    assert_match version.to_s, shell_output("#{bin}/uptermd version")

    output = shell_output("#{bin}/upterm config view")
    assert_match "# Upterm Configuration File", output
    assert_match "server: ssh://uptermd.upterm.dev:22", output
  end
end