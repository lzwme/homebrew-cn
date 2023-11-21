class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghproxy.com/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "82209896c9aae0d75441efeb1ac477c245033bce859d96af3bf740c7c0d8b012"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3828694b8b40f1cb4701c07f30d2defa8758080973d714860d88db7d73ba6c25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26704ff943e19592034f761a9e06e864b8837a4e2df1976d9ed738c2273400ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067decece508bb5820e6e5c78f964f88e7f144175dbc3ee6a29b6ccd6d281666"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b971a2b8fe92b2fcfaf3c4e9cf6381404c60f3cfa04ae331af154ab1cc1d9b2"
    sha256 cellar: :any_skip_relocation, ventura:        "161cfcc14717c6aa04bfc24d19f4d83206942b5237e4017623266fd73162ae7f"
    sha256 cellar: :any_skip_relocation, monterey:       "1c9d891d41b9dfb28518fd8d765c7e2fa893a828737517b0e9e740f5e5e17018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546aa518dc15d43d116b1b802d1920d9792bc5656bfba5b909387bfff894706d"
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