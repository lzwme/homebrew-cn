class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-06-19T19-52-50Z",
      revision: "f9b8d1c6999e65ab31899cbbe0314f5a4e5257c3"
  version "20230619195250"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dd5272d916d86d651165db3846a368d5275ad8a552c890bee20b5af9cf556c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4b3ea61fee4a8cce804fdee343d928989eb27ed55d192d11b3387df6c6bc3d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "656f7311179a59f03de8c3c6ba4fe44ba85ee2c669826eec8d607ce043c9fa83"
    sha256 cellar: :any_skip_relocation, ventura:        "afa59580823e56fa5f524d8db75ab63d369c233a875ac0bf2b37577455fe970c"
    sha256 cellar: :any_skip_relocation, monterey:       "4b461b892e0981de23d2d4a5d29b2cc91dba680a987bcb0ffe3ec84d21a2c911"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc61ca781ad19041b7e729e4238b57b8b611eb613b8f9decd3c05f1ab12ca6ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98bc1c100974a0a2884b37cde4ba3a6d42d69e1b30ca6bbd09faa0c3f29e0f16"
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