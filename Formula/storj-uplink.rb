class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.81.3.tar.gz"
  sha256 "f1c22ac526c7b324379bc517d386746aa4fafb880b574d5c0bf4795355b2f753"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee9b574411a19c1dc7d48fc9dde7270291c5a990e7d39d385353e0d3d30d82eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee9b574411a19c1dc7d48fc9dde7270291c5a990e7d39d385353e0d3d30d82eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee9b574411a19c1dc7d48fc9dde7270291c5a990e7d39d385353e0d3d30d82eb"
    sha256 cellar: :any_skip_relocation, ventura:        "1cbc50c79bc48bebed0a90c49bc9fc3ae9bc7fc28695a96069c913729941f265"
    sha256 cellar: :any_skip_relocation, monterey:       "1cbc50c79bc48bebed0a90c49bc9fc3ae9bc7fc28695a96069c913729941f265"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cbc50c79bc48bebed0a90c49bc9fc3ae9bc7fc28695a96069c913729941f265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5378475b58ef88164a1f2e2cc6fcab23c15cfbb43a4bd6190e60fe15244b06bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end