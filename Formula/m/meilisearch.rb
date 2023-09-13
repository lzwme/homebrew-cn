class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghproxy.com/https://github.com/meilisearch/meilisearch/archive/v1.3.4.tar.gz"
  sha256 "75a40fedfb04cbdf39e7ba5d50d1ee4ef43d9ea58b4c8aa4b22f182f9ef4579f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a94121797215a4feaf3731df3be66a37900ec96b9719c18b2f0e0f749adcc8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d68aebc1994a92ab4de0098976b8936daf3e4634f673434a723b04724b5d5632"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ecb9e139117fb634eecc541109904dbd4a3c8c0908a51582a7f95990afce4bb"
    sha256 cellar: :any_skip_relocation, ventura:        "fa9bc53acd12e900915fba104bf451a620ea4cbd8c487fb053f47ddc2acff035"
    sha256 cellar: :any_skip_relocation, monterey:       "1c5c267a3c607411a785bac72591ed68a23af05fadc6e9aff91b9e54f308ebb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "000903d790bc9b5467f93899753aea8898aea2952457b01f093f2d9ca6e34307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "153198972c437cd015bc01ad97d3b924883e4458ae8d975afac01012b67bb46d"
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