class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.11.3.tar.gz"
  sha256 "f07e4a2eb37c83dc4420661aef6b2efe3a9c2c9c139b55fea43415e893a5fb91"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c861fbaaf947a7795311ed531470e1e77da441b764512a650dbf88eccc414ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7044dde64242aee51607711b405e1e4ac4685b73181160e822e780f10f078699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf8fc5c53f16f820947060eb7f9006e4a0e458cc5f01243886c0702c9f717ce2"
    sha256 cellar: :any_skip_relocation, sonoma:        "65a18bf19a91b57d0356d97b984808f698e44be7754495e327c097d9b4c4e2c1"
    sha256 cellar: :any_skip_relocation, ventura:       "385fecf9964f92b5f4c7bd83f8d9b7a851f18d3cdde8a47423492cca15490f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "012947664dce999f19ed987d931fa1db0fad02d0eca55937ffca69291ecf8e6b"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
      system "cargo", "install", *std_cargo_args
    end
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