class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.12.3.tar.gz"
  sha256 "31af3b9df2e160926ee042555378c127ea2cbbb92e7b27aa6fb433bea635a601"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ce6422724434a4a80e5c78949a97b4c9ab2ee343d5ac62ff1d7f5e8af9c177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14f532bed337996470a32ca566a079dad5175ae9a895391e9dc6b7dfdff62093"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "092171378c11df2aaa9215837afd0a1a998901eabf5a945cd8dcc257e7091c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "760d5d273dd5cae4858784688248e131add5a5c78c6b6914e6ea560a6bb6c55e"
    sha256 cellar: :any_skip_relocation, ventura:       "eeb7ac7f10469607ec57d43ec2ae6574d84ca3ddd2d084b00e186493222b9f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f27d43d74762c951c7ba795ae818f555a400e1ac1ec1327a3ae4bf7c3d1ccd07"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesmeilisearch")
  end

  service do
    run [opt_bin"meilisearch", "--db-path", "#{var}meilisearchdata.ms"]
    keep_alive false
    working_dir var
    log_path var"logmeilisearch.log"
    error_log_path var"logmeilisearch.log"
  end

  test do
    port = free_port
    fork { exec bin"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}version")
    assert_match version.to_s, output
  end
end