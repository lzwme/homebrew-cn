class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-12-13T22-19-12Z",
      revision: "68b004a48f418ed9c4363b9faaf61a90d2f6f502"
  version "20241213221912"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6abf6c40387ca970b5197aba93b81346c7630e5740144c854841b1c7e868f72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e47fb79f6b8bd80c937b22831c04fe52f63bbdb82343a4ddd0429167d3944bf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dadb2808df56c980dd3ce81f61854bbf72efcbd1306e6b7279d5aacc0ab66cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb841f5b3cf9bdb0ad80315736e0127bd6b653623af2a7be90e052ac96a5805"
    sha256 cellar: :any_skip_relocation, ventura:       "e8acfb3eb4960b65874f42214a0fe8df4ad2e39dc609cadfa4e096b3ffa08d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da36cca0cba99b643f2c9b96fc0564d6cefddc0fe464dfd335de46e49a8302c8"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
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