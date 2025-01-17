class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.12.4.tar.gz"
  sha256 "a61d5677ac338913010bf0cef8d9e9204022725b6d3e2f28c6ae7c070e54d228"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70c50ec99b9ee449757427e56a55c1bf71fb87d2e1a7664e56dbb5801a74c17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c72b89995b870e3e8f55aaa3f01b5c3d8756e00e5bac72ae734928a1ee61460"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d9cb4276999da538acf7e26f45a7d32be233cd61b058dcbe58405d961225304"
    sha256 cellar: :any_skip_relocation, sonoma:        "a60928eec7d873908769088e7a8c049268798e3e8c5dfb9117b3d30dc8ebe6f1"
    sha256 cellar: :any_skip_relocation, ventura:       "ec1b11271cb9eb4820f15e59c100d0d8ae97b8e1f234f56dde38dc439b2ee237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2cb70fdf11eca8d20eceddc4bcb10c2ef6ce0313fd2c3ae587a544b86e3ae7"
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