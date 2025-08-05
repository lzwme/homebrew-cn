class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "d923cf18558c694ba4db1eeaaa3ba0b7ec86f85573e7ce1efea45627c60bba93"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4795dbf9e5a6d08d59bd76d4c54847af12ee1b99ffafbbfc68a7af090d7108f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c85d14756edf10b567936e655cdbfb9ac3a48778ff9eec52550008eebd493c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3986fa07c708584151e338209a33b6822f4c478986e333058e03e0d0c727f2a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "abacd5d25c3f54d02ef87c74d4eff9ab7b59269cb82906d8ba5a1e51078c5999"
    sha256 cellar: :any_skip_relocation, ventura:       "ba941cb80caf0557db2dd4916d672e25011a7f8c49af459efab3db5264380eed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b8c0487bb20656da9a08166a3846798e704fa40d029e128de55c6548c5e53ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "947d9f549fd0e0d65e87a17f4edf3306cd88a26207631d0ab5054ad8e02cad30"
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