class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.47.0.tar.gz"
  sha256 "1170cceef2d2b454ce12d8ef4b044d28facbd5d69c0da91438986ae6e387fabf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01559566eaa063be29e6f9809fcdd846433e6da889b4796470e35a88522a630c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63da519e49c0152cd9b9dada4c548862790b1d065def3f6e706dd7ead5dd4d57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b48c61b8518ba3f30b4bf73a70f2473bec60a9003e4d4259f321d82e17fe1d26"
    sha256 cellar: :any_skip_relocation, sonoma:        "188e76f60e44a9766aa8b455bde7071cbe6166a3ed5b83b173ecf8ff69467cd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b66e0a8576ec2f59b5288d235169930724127ba73ca44b25f67ae6829bade99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cb5fe6279393f14281e5a34ae521406195196113da8939f7f834e212909a6d5"
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