class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.56.3.tar.gz"
  sha256 "8a27ef9ebe211dfb0ccd6c196021b214fefcda6f3a5c6860c9242fe85226bd51"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f9d8a3eac784d99530bda505ae1465c54ca944a8178d54faa9343fc152d913c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a855a3b85170cfaf0ba99960642905afdae27a2e5b2d3d796f63402e9eb082d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bffcbda99a117aaa43fdc1b52af36b91069c6d3ae6964e21b24e99f7543edf6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "db77928c66fd63d37f12c5c02a2f995cb060562db855a49e66b7c68e1010b72a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f3db549f77146084fc9f32e17b060a2180b2ad94253fe3fa83c8192a4ce9e6"
    sha256 cellar: :any,                 x86_64_linux:  "5ee6aa94ae13e908d1e8e6d0f03b5d303b4ef0e2ee92102857f3df9ae3028f75"
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