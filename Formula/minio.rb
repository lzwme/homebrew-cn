class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-06-16T02-41-06Z",
      revision: "25db1e4eca2f81b760446147006fe255e240e4be"
  version "20230616024106"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "177468851cd2ab6238708bb295d13f218e225a28b0e18740847445ecd2102d3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "848c707f3d75f3218e081c39b9f2c8f759063782bdcb1089c6f5a19291ee6e51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14e4dfcfefff2727e216d429c23d9d7b798a8fdc65563103ff378ca983575ce3"
    sha256 cellar: :any_skip_relocation, ventura:        "7bdff1771decb9268ca003f216b600185e89280d94f4f8295269900d19bbde97"
    sha256 cellar: :any_skip_relocation, monterey:       "20ab45ca021033bee031249602ff70e9c3db7efec918b217bcab3e7089bfcb2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ede6fda9ea732637590cb3855e774dd302db4a69a05e98b86cc31fe8f55e6acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464ea688cf329f66d9f20bd76a29727af14c69aa3f515158f8c0dd2f8bcb9316"
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