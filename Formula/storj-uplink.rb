class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.83.2.tar.gz"
  sha256 "b7a5e08bdc5f7a6631bd61887ae5732c61f07dfcc0e0da1f4639ce19d0a110a6"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb9080bd6fb270e434d9fa5eb0e25e1ce529e881aa18d0d7ec1d45cadcee40d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb9080bd6fb270e434d9fa5eb0e25e1ce529e881aa18d0d7ec1d45cadcee40d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb9080bd6fb270e434d9fa5eb0e25e1ce529e881aa18d0d7ec1d45cadcee40d7"
    sha256 cellar: :any_skip_relocation, ventura:        "a297ecf510f4eda4eaa04ae176d83ced920f827c8fad4642e939771813f17714"
    sha256 cellar: :any_skip_relocation, monterey:       "a297ecf510f4eda4eaa04ae176d83ced920f827c8fad4642e939771813f17714"
    sha256 cellar: :any_skip_relocation, big_sur:        "a297ecf510f4eda4eaa04ae176d83ced920f827c8fad4642e939771813f17714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bcab740f8a47ad06f6d3d4ab6ff7bdedf43053637fb13d624ad022a83584fef"
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