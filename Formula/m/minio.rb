class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2025-03-12T18-04-18Z",
      revision: "dbf31af6cb0d5ea33b277b6e461cfea98262778e"
  version "2025-03-12T18-04-18Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https:github.comminiominio.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ec0f109f47d0c8cbeaf4314743d7f09e6a83907a76dd85cd80cc71895db737f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9299245ae5edb8c1badcb5da7fa8fc134e39a1b86ca458e10842d45254c6c9c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54589eaecd28ceddc93ff07f66b9ff35397909ffee642ed534df32e4f0b74389"
    sha256 cellar: :any_skip_relocation, sonoma:        "921ebe44477f6cc71d345fd87efaa5872819e9e7225341f3918bde9d1017dd74"
    sha256 cellar: :any_skip_relocation, ventura:       "ebe4a340cce88f135ea2e02ef93e41393162493e2e8b9063b07070b87d52da6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6098c75e3de0ccf3d543a07c924adf47c1161ddab9684644d977ef9dcc17c63e"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.comminiominiocmd.Version=#{minio_version}
        -X github.comminiominiocmd.ReleaseTag=#{minio_release}
        -X github.comminiominiocmd.CommitID=#{Utils.git_head}
        -X github.comminiominiocmd.CopyrightYear=#{version.major}
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
    output = shell_output("#{bin}minio --version 2>&1")
    assert_equal version.to_s, output[(?:RELEASE[._-]?)?([\dTZ-]+), 1], "`version` is incorrect"

    output = shell_output("#{bin}minio server --help 2>&1")
    assert_match "minio server - start object storage server", output
  end
end