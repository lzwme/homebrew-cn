class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with SubsonicAirsonic"
  homepage "https:www.navidrome.org"
  url "https:github.comnavidromenavidromearchiverefstagsv0.53.2.tar.gz"
  sha256 "b560cb17ca84d206d9128488ad743c6f57185a398ccfe7e1340389ce2f4da9d3"
  license "GPL-3.0-only"
  head "https:github.comnavidromenavidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d089163457db1ae16ebee1ebe85e3b0db05f136c1e59ee83a9ca575a988ae0b7"
    sha256 cellar: :any,                 arm64_sonoma:  "6843ec90592264a1d92e74a19e3b1c9ad9056ce75845bd692773c6a148a83cad"
    sha256 cellar: :any,                 arm64_ventura: "d888dfac6c8ced5b96818d206e888fb79c7b9f44ecb6aad4b7395408582fd72e"
    sha256 cellar: :any,                 sonoma:        "1fc8759c7badc18d2441b4ac5ff1b2e1d20c61e73ae08f330410a8acae24425d"
    sha256 cellar: :any,                 ventura:       "89e42425be7882dbe938f1efdb2a8a4ffad1155990831d51e75584613a745093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190d02bbd8a078eddbc559f93e4e4f96e5195206274ab2f5be5fce8f0a4d4c7b"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags: "-X github.comnavidromenavidromeconsts.gitTag=v#{version} -X github.comnavidromenavidromeconsts.gitSha=source_archive"), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}navidrome --version").chomp
    port = free_port
    pid = fork do
      exec bin"navidrome", "--port", port.to_s
    end
    sleep 15
    assert_equal ".", shell_output("curl http:localhost:#{port}ping")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end