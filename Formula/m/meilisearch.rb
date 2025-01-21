class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.12.5.tar.gz"
  sha256 "c93218acbb1dc909a6a00f5b536f6b487d52b2dd4b59211706f28d15fb5b13e3"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a794ccae11ee9f8d2b2196c93fb35d17e5b7f74adf694613d1931cfa1752214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adddd25c0482e7a8cd06729e5e7eb7b0a346e5e10d0c327f1ce659bdc776d378"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "960d1513121a70f10af0b607161ea59be59a627980d1fd6874a3dafd0efe93c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a2f985f5065e359cb545bf876ee326285d9b77a3c3f3e0a89f18d4884884fe"
    sha256 cellar: :any_skip_relocation, ventura:       "b0d45abbc1cdae36a1252b57b802ace18b8aeb273ebad3a4e08af34da3ef4141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73b099749b0b29c8fdb135686747ffb0f0fa90bfe0672f70dd6e959aefab1d59"
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