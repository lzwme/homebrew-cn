class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "3b70fb2ba32566c77fd84490e4dd32951dbcbe433f060e3499542bf78a904631"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3d4810b8c0a4975f6547facb042d9938600539124bf084c06b22a870921ed8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb44fa8dca92d523afc2ae28e1b22094b98addbbf11882df98bc5f4740562a9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47a1ebb8daef228dd1fced597a81ed1d4f927b11a7e5e96f89d06c474ee7a4b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "77669c26192d9af02bdf78d22b02c0b773528d411ce706253f2f5011f4cb3df9"
    sha256 cellar: :any,                 arm64_linux:   "bc39bafc6b6b77129fb005e9622c6176a3efb4ea2c823694ce44c14ca44e17f3"
    sha256 cellar: :any,                 x86_64_linux:  "60f3b93da5f3c769c5cc298e071a6473cc6a5d7bff477b52591946d67547cb71"
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