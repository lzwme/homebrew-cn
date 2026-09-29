class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.63.0.tar.gz"
  sha256 "9b3ed64890943fb2f5ec0750807abcea45cd439b9ff56582ff6c71a20584b794"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43d0524453c62696b37c1e7c0825d54b93597e6d74f928170c8d52827ee1e76d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b4c9fcad3d61669d183ca0d28feb98bfc634dff9bcd6dd7ee98d264a57df91f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4d1a475a6e70796d631eafc75b66f65684e19776dd8491f167463d4cdcc68b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae193a613d84b391bb212cb5ac669edc7da2ece2e8d54f7e311666baef607fb1"
    sha256 cellar: :any,                 x86_64_linux:      "a143b8ae0b316f07d83eb911d76a838b308ea544052cad3f9adde11a1225413e"
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