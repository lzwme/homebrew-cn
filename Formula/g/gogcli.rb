class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "c31feeb39bc8fdef38ffe2aa31bd62a812d724efbaff1262d94e20a3c5c8c032"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d8536d764b6c1f693473b4a778ff56b39eee2d9c0403f1c7ed2845ee91c787e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77433ea4ebedca153647c6c2dddf04ea63c8408dcfcf6fa76a35725bdf695f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abe36b6231bca3d5f632ac117603f464b62438451e0619d60603caa3726b2199"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d0fc26e11632cd7b42dde04bcf9adcacab1a62213a6b642b3775a840f1d517c"
    sha256 cellar: :any,                 x86_64_linux:      "3aab6bab7cff1037f86186e45443729ea6faf6a89bf3c665f75523e43d13be24"
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