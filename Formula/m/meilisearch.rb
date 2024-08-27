class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.10.0.tar.gz"
  sha256 "c997c00a3b8295100df8695bbb75e011a4fd7bf73a3cfed81d6462b96d29a951"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b04a60ba76fabdf05369b32f8c34119b2b25d75f38189f951b9fdd7abbb35d90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "788697f9b79da8b400c5070305a1232a3ae4c644e0a46fd2679fd9d9f85386d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b40c691fb7554ef0e410dfadae7b81cc6d784df1ba326e422deb3b872c180955"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d5d8eb4d9561d3ee5911aad0040ec9b6b25adfe6c10600e906a162c0e8fa5c9"
    sha256 cellar: :any_skip_relocation, ventura:        "c679ec7d37fecea186bbf195be05706e8c5e364cf5671895df6a3fdcb44437bd"
    sha256 cellar: :any_skip_relocation, monterey:       "d66c449e15f8efbb585c3af1b8a218619b7a18c4bbba9039fa02e2019d2f7a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caa1c12d8ba71f859cb6a53680b039e2379c6f7221afce3d5d66d9a899e88911"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
      system "cargo", "install", *std_cargo_args
    end
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