class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "062129e495b595e0f49e48526f0a826228705ec85ce1ebf2ea29ac5e37fc1abf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb5cd5e6600fc2d20da26a3ee6e9d6eedd6a81273d6508caa2398bc6f578603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2d19ce60d1a293170a384ab20bdd77bda15d01e68eae6bdd071130a57e9a288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef1f439dc4909a34b032ab5bbf6d1693468132c53a0a6659f52ae57475252cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad0b1a57e9db3783277f2a8558d5637211cc7cf43c88576ecbab74bec51e0e0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "051db1a8ad130512a31ee0c3b4dc645c5c8482fa75fa88c7f73875afb3fe83dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8bb69f9e6ea21b42c02d2b8710bed4f1159474a0739c669aca64a158e2c1cc5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end