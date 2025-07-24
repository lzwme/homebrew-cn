class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-07-23T15-54-02Z",
      revision: "7ced9663e6a791fef9dc6be798ff24cda9c730ac"
  version "2025-07-23T15-54-02Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a620a0c7382cd3658e57bd083106ceae8d915c06642b8004b2eec043923cb42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bed03ce398978a5a5aea0a602abe85902c9c5242020fd0cbbf489e25f8f4017"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ac2e0fde5fad1bf2e5e949e8f58504468badc6cba487611948d349ddaa20b01"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ae9daa0149e18bf2725050b830ed0b6f70c86e33013728e38825f918c7d537e"
    sha256 cellar: :any_skip_relocation, ventura:       "498acacacde4f2daccd79dee95fb7188fb464d49a7d89dbf4b9331e51c9c6f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eaba04c480de19252536c0c1b5e0982c6dbf45c025e9055916a0b4314ab8389"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{minio_version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{minio_release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
        -X github.com/minio/minio/cmd.CopyrightYear=#{version.major}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--certs-dir=#{etc}/minio/certs", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    output = shell_output("#{bin}/minio --version 2>&1")
    assert_equal version.to_s, output[/(?:RELEASE[._-]?)?([\dTZ-]+)/, 1], "`version` is incorrect"

    output = shell_output("#{bin}/minio server --help 2>&1")
    assert_match "minio server - start object storage server", output
  end
end