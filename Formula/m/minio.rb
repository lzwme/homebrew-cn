class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-08-29T23-07-35Z",
      revision: "07b1281046c8934c47184d1b56c78995ef960f7d"
  version "20230829230735"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1a8c0e19b48eb85b8e033b2f802629e970c8217a24eaa02e760b26bb3a02555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41e5f67ef3692be5a5fd801bcb8f7abb23fb080a86a3e05fd80befeae50e03d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8cdd9d0c2e597645601b52a2851a031688651cab30927a0f7cc34c51009bb9e"
    sha256 cellar: :any_skip_relocation, ventura:        "0e2f9fbab56446bd622413546f25aded47bf00cf89a169318a7c8f75ec8d0165"
    sha256 cellar: :any_skip_relocation, monterey:       "3c81333ed8c245ae72981e4f19cec9e54f301097553d7f40da2a38f5acb2a3f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9471ad72bcc701ef08b2932a38b0e00a0c24a76d293358acedc0c1a040861129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6604478a3ac821f516b425da01efa6a6bc1583361cb2807ebaa43ca6cd4c9a33"
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