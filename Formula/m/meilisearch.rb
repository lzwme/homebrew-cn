class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "40774deff25cd4050397474b17dbfbf6221e9c1e878eb861e93ab389f82b8198"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7b5c128c04d56e86bfdf7a1e3e703bd9d0974ea3fbfd084d7189f6442867e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7397415ee6c6d7dcb3df28d41c0ce3a34e4ffb1eead17f4005719820b471b91c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a7b87b36e5fa09904f607179c13326b7f21059c5338c3e920ac33c3eea8fbed"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7102d2faccfd0c8ccdb64883309a13636e240865f08d791bad0749d7b89696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2603dc339301d36bd7a69de20ea9089f4b97baae14744cafb150483c4d3ef95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75c793b5526a42e53fdd88c1e5cbff4544193a3e8875c77bd5bfb4145b9170f5"
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