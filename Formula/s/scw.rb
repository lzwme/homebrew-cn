class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.64.0.tar.gz"
  sha256 "80112419dc52b40c1da36b71dd58821fd14da6aa7a5c133ce84f3405d5f95433"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57df515dbbee6ac178c64c2c448d6f03bd0190561e15a13847f9bcd53bd4b7ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dad8a2672f5764afe27aeaadcb0c0235539df51ffb6e9c3ccfb9afa46978ff64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f36281b71fabc39104a14042fbb08ff4c3a88b943e26b18e3c8c8dacbb16203"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27b16d1a334bbec5410eb4dfe0a3cf40d00631cbed7a5aa746cea7f5a4b7f987"
    sha256 cellar: :any,                 x86_64_linux:      "e89384ead1389ff538ab3ae3ee9b380bf6d5637f5ea8abac96b8352a0131328d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end