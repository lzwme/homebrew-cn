class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-10-14T05-17-22Z",
      revision: "78f1f69d57fc4e347887ebee45d7f11e6916585a"
  version "20231014051722"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab8fa2dde31bb3c920939587ad1160abd37179ea6863b912c99bb12e31164f82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9be5b18c04799946c9d01e7d5f9a59d26147224f50b34178c6eccffcb32980d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06bad2f47932399a9e8ef7690d1e43279c51981257e20ea2203f8df14b02d166"
    sha256 cellar: :any_skip_relocation, sonoma:         "047ff65a2fe3a1cbbd1714c3b4385c353715f2171966146da01c26f122fd2c3e"
    sha256 cellar: :any_skip_relocation, ventura:        "44c1f37a17d95fdc291b2251842ccfc32528162da5e625c0aa684d96c0e68e00"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c595a32095819d0d0930f0e2e9b76934decc02f0c4c8bec4465ec17c4cf0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60bbc91c57d79ec4744e95352912775d7d64ddf15ada649115f2a6914e2054b5"
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