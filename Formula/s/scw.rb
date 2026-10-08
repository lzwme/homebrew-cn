class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.65.0.tar.gz"
  sha256 "60b1da3b4040be8ace2baaaea8dae1f2fa2614424cca0963bc814a6b60471352"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8150e3b717fac50b4d5f4279145898904dfc8be44093750d9d6b24439d81d6ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77bc194a472a94db2c0c86c488eb5266267067677697cc81ce2ad60152b3bfdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87d4994dc431dc9a863583e84d73e7906d5df8012402cfadd40b611cdad1929a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "538bcdf2c7298c68cf37ac519c96f55ef90b566cb9701ee1688761c6eba17e8c"
    sha256 cellar: :any,                 x86_64_linux:      "5ac7510e08a66d2be88f030449e62c2e6f61113b754e93b69a2e18b1e8813387"
  end

  depends_on "go" => :build

  # Avoid looking for the module root at CLI startup, upstream PR ref, https://github.com/scaleway/scaleway-cli/pull/6379
  patch do
    url "https://github.com/scaleway/scaleway-cli/commit/39dc3996fbd9ae8ceef04af41bda8261d11a12b5.patch?full_index=1"
    sha256 "bf3b72864cb2e93bd8fbb3fef100a6bad2241c91b46f6a2d6179e831bd55e9e9"
    type :backport
    resolves "https://github.com/scaleway/scaleway-cli/pull/6379"
  end

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