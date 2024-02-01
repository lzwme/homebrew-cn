class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.6.1.tar.gz"
  sha256 "c38383cf75e7dd9e8eeddfc0f17624844f07678e24fda07ed1217def3683da2d"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3e1cacd700e0675e4b59c7956f8f797bb6e24dd7ac521c572f5ff067f62edbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5e8e432a8fdbf834f8be1225ec69bc2ec68354ab5e6ec2ac5785ae18131a1f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "630c5781722942dde53d0f57e5cbeaec9fa49480f318095f3c5007bc7d8bfe90"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ee6747d227209371d2f8d7b1326818e411238c997b7c3c6054ae8e5418c7a81"
    sha256 cellar: :any_skip_relocation, ventura:        "1143cd00f60de6fe757c160d49990f815b9463bb87bbf688fbb40e2178ba4b68"
    sha256 cellar: :any_skip_relocation, monterey:       "db732511ca8c9ed21e0fd31d021de2cf595f5c59f4b960035af5b407dc8212c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7446224a7a4c3a9c2027fc10e9073b3416afccfb41c00cf9202de1410198f893"
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