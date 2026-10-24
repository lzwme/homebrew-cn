class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "b8155478a8ae0a8af0fb9d8f943362cdf24f6a4ffd45c60cb19b9927f1c9aa93"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac4bbb4691c99901e1d86b031971535856c7cc5781c659df690f768f20c73ada"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed36ebbc8aa450fd7c28311d2e59a3981e741df1df6eb36ccb83aba1fb3c76bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40de28214139f836066a188b5790214ffc46719f77145fb5be1b319be615e151"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3b4b4f0082105402037425b2c6c8d6d722c9ebe46c9a977deb07c99fac677915"
    sha256 cellar: :any,                 x86_64_linux:      "90e970e9d1ad53cbec9b5c43058ee3e4b371de1ee81c9bfdda8c481e162577f1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end