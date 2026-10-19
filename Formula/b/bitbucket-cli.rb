class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://ghfast.top/https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "509d013e2c6a0ae68c20fb01e78096cce40647a65ac935a48b9249aebe57a504"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df7f7d63c402fe6ea3af5af0a25bedb6c579711c7ea71519c4ee512441eb52a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e279c18a9f55d87ed910a28615c4af28d9162a9ccf624596c4e2d48d5c43f8ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3429de6f4786047f15a20f03acf1c4cc96cb00e890673ac40002c4cf01f5ad82"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "42ba38391daa30289cc9f083228f4a134b9e6014629f3cb8ddb8f0d79c12a5a5"
    sha256 cellar: :any,                 x86_64_linux:      "eec72e367532b3ba96fbc08bbac7135d211b723dbee5973e3af24f147af3fa8c"
  end

  depends_on "go" => :build

  conflicts_with "bkt", because: "both install `bkt` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/avivsinai/bitbucket-cli/internal/build.versionFromLdflags=#{version}
      -X github.com/avivsinai/bitbucket-cli/internal/build.dateFromLdflags=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bkt"), "./cmd/bkt"
    generate_completions_from_executable(bin/"bkt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkt --version")
    assert_match "No contexts configured", shell_output("#{bin}/bkt context list")
    assert_match "no active context", shell_output("#{bin}/bkt repo list 2>&1", 1)
  end
end