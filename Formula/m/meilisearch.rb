class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.8.3.tar.gz"
  sha256 "99a08b9622caacf77645809caa81e69702f2600fd2f37c4a0f02874f4b671887"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cac522cabfa072112e32817564abe7f56befc51f712c61e9016d954395ca3ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ba627d8af286011bb465627677ca45ea31538276189b6a82b28e335a8d595d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c910375c2b5fdd7c0a5e983a9db5789297eb71bd56938b5e88866afda7db8a62"
    sha256 cellar: :any_skip_relocation, sonoma:         "8035bf2d4ff2e3c5cea4cafc95d439d0659df2132a9fe214470a0857fe5567b6"
    sha256 cellar: :any_skip_relocation, ventura:        "499f9bcc69f20a8b34901b90a7009003b1d5b37355854c528dd7026fda9e28e8"
    sha256 cellar: :any_skip_relocation, monterey:       "fdb83653762bdc7df8638954b358516a543040596b8c86bb224034467a3be2b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b12b7b401dd339bcf090f3602ac66166868e9860a67eccc9a25b79139498e215"
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