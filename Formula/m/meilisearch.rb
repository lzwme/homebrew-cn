class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "d2c8e942af882f6d5cfa49f0d4a42434eca8a52b7e032b10ea74b055010d6ab4"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "318b62667a09a19cb12ec30062febd7f909877d173704b9596ee130a27e19b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffcb72357aa1ed3dce07949ee15039d6a20077941fdb12a3520ddee7e4405325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ddcadab2993af8694d55700e6f7ed0200377fa5cbc408233b2ff49b1e602917"
    sha256 cellar: :any_skip_relocation, sonoma:        "82bc4d1561cc5002b5643d8fe981328eb855eebb781ff75c962590f3e4c7059d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a8ea5ab0ee3219ade1f993e6e35c923b1cad2609053eda49586f903837bfa35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d904401d3d93e69827eeded4c52bdb79a70a33badff24b6b55cfb8977c9ad0c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    spawn bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end