class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "0a2b9df0449d0e745ce8d15fcfdde320f36ff4aa7b20af6879e08f5b01c4c37b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51e58caf4a09ad128143184cbab357ce3d536d8e20024ca3fbdc8a84d6d0f9cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988d05b534ca54479223ffba5bf4110e535e718508bfbacdf3943ea27e64b160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b83284f6eea6c304a0f37c2cbf4388aa3d46f59968f55791b4c715aa25303f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcb0f8bffb7674160411bf5e116440e753ae4db17725b4de17ef080dc7a0e09c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82047fb59f6821ec104d52787a36b6dbdc5e34b0ab7696c98aa642488c6094be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d08cd14e058a8e48b52d3f33862c0b50de5bfba5563657f2f450173fe84cf74"
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
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end