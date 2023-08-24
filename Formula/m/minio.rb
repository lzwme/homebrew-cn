class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-08-23T10-07-06Z",
      revision: "af564b8ba07a7805a578b5f6f2b3827490f74ccd"
  version "20230823100706"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f794c5101b221be51b2afac95892a57ce91153ffa8b94ca404b879bf80008460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0856e7f0630651ca10eff482f1b5458d651e47c69e7f60966188e603fd675031"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca89e171f59d282295b7da88614b900516bcfb0ced6afc1ef8df6210be7035e2"
    sha256 cellar: :any_skip_relocation, ventura:        "8f56684d51df3b80b81b2859fdb92b5dfae50a06e1780dc991a53aaec14f6974"
    sha256 cellar: :any_skip_relocation, monterey:       "9e4de3935b25b80a4565be236ab74918c28c70b419efbbe98a3ed629e8131c2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "df43cfa58824a106feca27745543a77c185f6c8f83f7d8fc9b9da86293c9f039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7e9b584476e519eccbcaece897cd3c9aa938e353d991d51f216c621b8c57d2"
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