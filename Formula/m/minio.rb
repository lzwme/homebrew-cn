class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-08-31T15-31-16Z",
      revision: "e47e625f73bb1c9672e6c8e4c3b3f9a0e93423a0"
  version "20230831153116"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40d1ad9f316a48233b5dd6eaeb0c8181907f68a3e0456b6e9920bd179dd47a2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a7485ab402af2a23b7485f3c31057e9a8802f1ae094ccc49a39782c5ce06ca2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46f2669f037abb7249554a0eea402a92d7e81a60ecff7970e3412180bba27717"
    sha256 cellar: :any_skip_relocation, ventura:        "764899126c596d865fd0cdbcac68867de219d8c9359781c2d307b729232fbf64"
    sha256 cellar: :any_skip_relocation, monterey:       "323d0694b513104dd59fdeb560b53c5ce816101f352c299deaa1ea6cdba944f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "faa84514da15469aa9afdccebcf93b9a496804cee4e233d11117ad63890ea0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f92148305a0766c1938ff25782fd2f8a979215b9941462f162e2012f6421cb"
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