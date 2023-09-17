class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-09-16T01-01-47Z",
      revision: "b733e6e83cee28820e815787b0562d17b14f9759"
  version "20230916010147"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "370fd715a9ee4f775893e82ea462bcee4f32eed047dec042a4ba0a93220a32ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14f5c28cf6fd8fc78edc653001aec6595632d8cdcc7a692ffb179a8f67a025f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c4476fd8f2bac75a3af921744cb08839862cf094582ab70ed368c03907b0cee"
    sha256 cellar: :any_skip_relocation, ventura:        "930b177e5565812240763450a1cea73cb389ac9306fad2d3656521dbc3f5d013"
    sha256 cellar: :any_skip_relocation, monterey:       "b49a71f619842ff6784c92467faf208cd08439ef0e649307ea56fd09d08499e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb035b2c164cb3d9ef52ad76789f0c113ea1568358088ab815e45304d584e477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8cb3440e7b2e73e90b8f93ede172ef8a257e7bdd506a1eb4211b2b7e17b54b"
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