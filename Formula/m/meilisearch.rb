class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.6.0.tar.gz"
  sha256 "d5d8a95c0423b3181b3b59acb6f1f097a4e181656ec5a4f47c8e1549569601b6"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79a1c87ffab872ca4a03997172530e7cd93c830a73d43dd98892573f5e0644b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52d5d93a4d5986986e9dfb845c446e60c69654dbabec61b6ef326e9206c47d3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daaab8ccaf3e619acc574b80638c2d7c231bc30a7043eacd520f91d51570e5d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "49d30d7222d6af3fcb7425fe62cc96c7e7a53088bbf7d4ed3b4955243b1f0104"
    sha256 cellar: :any_skip_relocation, ventura:        "ad5e720fd6f7edb91a4230e8994e52485b41fa9e87f7e3638aa4e87144667d3f"
    sha256 cellar: :any_skip_relocation, monterey:       "4a0ae77284d087e96ac30e00ba99ed0d6760727490bde20308ac67df3525c801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6a69d7f54ca3fbc638a1a290bb7ecf24a02e7870cc7db1eeda810fc1ff9f32f"
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