class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-06-29T05-12-28Z",
      revision: "aae684641325e1c37375d455c790e58d902bd7b6"
  version "20230629051228"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2ea3af74a805e30f534f55d472870aeff329fb248ab7523be345135040eab89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79addc274b5c4b2e8a71944c1e00a72ec0b3c65cd524e26792175a8ddec91f06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34465fd890041fd3d8a0f2ed4629c6ddad144f5d15b54d17078720f469d7e88f"
    sha256 cellar: :any_skip_relocation, ventura:        "f704bb102ea3f3bd2b74bbe218063c67c78b7f08c418de144e11b15cf0e0e9e2"
    sha256 cellar: :any_skip_relocation, monterey:       "7b06b614d2414bdd59604b2c359fb3217d647ff75fc14c054efbaa9b5e16e93a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa01122ea963aa1a4a264e382173ea008e3f09ad0cd264f08032a7bc45a4c140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28dd8f122baf76a50c52b16ccbabab9d3475ec1df083745ed9945b2fe8928264"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end