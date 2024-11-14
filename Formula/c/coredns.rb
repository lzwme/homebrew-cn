class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https:coredns.io"
  url "https:github.comcorednscorednsarchiverefstagsv1.11.4.tar.gz"
  sha256 "19c3b34f99921c129a19797710ddcc35f974655c99914cc319ccd0ba14f13e57"
  license "Apache-2.0"
  head "https:github.comcorednscoredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df1e46f69cd5a22c625a705dcc4cae6d56bf87f9ccd424f200277410682fcf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e567753c4f0c9dea23461b9112d5e0ba59613761ed2ecb752132f4ee3108f53a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "123abc8511053b328239eb3d00d25570d924b63ac51a7967420a9bf16cbefe18"
    sha256 cellar: :any_skip_relocation, sonoma:        "022edec861e30208b144464107f65cc4f843b90a2c2e07117f4adb5148638e2d"
    sha256 cellar: :any_skip_relocation, ventura:       "eef50dbfea8a91a19ac260df408abc557939aac33cc7f56cf4099c79a6448615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96849ba4b9da8607fa6a6564e5ae59036e64a0596592469b221e3b2a3f17b7ad"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  service do
    run [opt_bin"coredns", "-conf", etc"corednsCorefile"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var"logcoredns.log"
    error_log_path var"logcoredns.log"
  end

  test do
    port = free_port
    fork do
      exec bin"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n, output)
  end
end