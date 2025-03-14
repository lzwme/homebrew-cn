class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2025-03-12T18-04-18Z",
      revision: "dbf31af6cb0d5ea33b277b6e461cfea98262778e"
  version "20250312180418"
  license "AGPL-3.0-or-later"
  head "https:github.comminiominio.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11121a30e4a8c2222e23be0aebd80f38b99f5484d12e9b75efc5c47e64882101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a00d0a3d47c63de0a6504652872a825db58232aed2c701406ca23f76d232f14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5572276470f7e7afc1e32f30ecdb00da79aa2247c5606196fc7725927911cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac414c58ee2ff2026d78c57b24ad5cfc05c6fa1708b3cf7e9cece5ccab417cc0"
    sha256 cellar: :any_skip_relocation, ventura:       "e92d8dfd16b54d386a5656e75738795933d3d30008b171a0ffe7253ffea1ca6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "154dae3e6692d9557869d7958354a5a529d0933d9ff63a73099dc7a5c9321110"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = stable.specs[:tag]
      version = release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.comminiominiocmd.Version=#{version}
        -X github.comminiominiocmd.ReleaseTag=#{release}
        -X github.comminiominiocmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var"minio").mkpath
    (etc"minio").mkpath
  end

  service do
    run [opt_bin"minio", "server", "--certs-dir=#{etc}miniocerts", "--address=:9000", var"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logminio.log"
    error_log_path var"logminio.log"
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}minio --version 2>&1")
                   .match((?:RELEASE[._-]?)?([\dTZ-]+))
                   .to_s
                   .gsub([^\d], ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}minio server --help 2>&1")
  end
end