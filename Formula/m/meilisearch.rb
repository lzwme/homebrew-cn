class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "191fd8f5cee07489cd7ff0d8416cc319771fb7d473588842081bdc0c63fc5d87"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "594c8373703a518b2fcd15618603bf6554935a201314166c7cce953a7f86b938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5783996ca56e00355ab5999eacc064a51dc08ae572a82a9d5a9c3eaaec218c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83e5d52fd65f47a540739ae9baf92b9aa2de62a2ce7abe7d65161d6d742cd91"
    sha256 cellar: :any_skip_relocation, sonoma:        "183cc5edcfe321f1dea77b1ef964f5bde0bdf2ea8c94dc699425af93619fcc2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3ab7cca469d057cc56ab26375962717ba4d092a4eebf36b3d26579593e402ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "236771e4cd08d00e72e83d170c9b009efcc099809103687f6815110d6f33d66b"
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