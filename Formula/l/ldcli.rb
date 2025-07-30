class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "70f9bfb1465c91c920c60dd6673df3668850a715a2442b428d49153ad585e1a4"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d49600a97d221a34afb959a9113d93b31736c621b036c9df2a24f170e153e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0478273db0abd362c83734b0cfdb15449ff6dfe79d68b7178d6942d80c1145d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01ede8a5e4a7107d54c877934ff760975759e1b2a536d947b11f55f35fdfbbfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "99d3e00c48bd4c3520d25c01c2e29034665a1933f37fb87d657afe7f331d5939"
    sha256 cellar: :any_skip_relocation, ventura:       "0966d3b6879687ea7fdb1513dd840678ce72a7378e98972fe537bc13ac8a1c4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a58b26c91270d86ba144eff228d281ab4fb8cc3bed9cd8e34a39207cec9c4703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc6969c9d341be1e97a2a2207e1e5c1657978b5ed35b5b87cc31647e4ded370d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end