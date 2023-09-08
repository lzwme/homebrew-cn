class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghproxy.com/https://github.com/meilisearch/meilisearch/archive/v1.3.3.tar.gz"
  sha256 "d51ba58c6d4adfbdfcdaae91b45625c0f2ad0e0c606c4ca2bafc28648e9ee626"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2662c706937a8f22b307b2c12ceeee74361e3f7f2dcf62d3bdd7199009b63b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4646be5078a9f256e6fa382305eff365c799bdfbeb99c20fda27e06e2d4a9b06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1f0d2fcefc1b90f494cce4f215d8d6b28b2ede7e535c9a4a8e657bea8110dc9"
    sha256 cellar: :any_skip_relocation, ventura:        "0ed839a8aef709422d209f4e6b0e3257b50a972ae6943e5d3d6b0bc8c87002de"
    sha256 cellar: :any_skip_relocation, monterey:       "9bc625e23a312b3f88be04aecd14bc0089b48abf59d76b6e3d2675f31d2564a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e583d4083c7959457c22ab6cbc45773897d38d7f0cadf863e46b563eb188cdbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "facba3a3abaabcfd53af13c05f5fbb2e901fd5b668bab79899b3604f913a80f7"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
      system "cargo", "install", *std_cargo_args
    end
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