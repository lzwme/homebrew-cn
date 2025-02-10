class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2025-02-07T23-21-09Z",
      revision: "703f51164d3d0c44af41b0d86075a1f61e4779e7"
  version "20250207232109"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "612320fb7e941b1d4728e5b46a3e12658086adcff7568906d1548d0dd8794ccd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eb5b8fe88cf0e56e7497ab6991789eaa29cccb3d2851df739c3756adcf2c173"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d43f412a63de31a671514f59c448a57909c28ef89434ea9187b2de54124e4aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3934ce2bafee939a744093ace83878fd806bef37b4e70a4bd2e9593a38608b30"
    sha256 cellar: :any_skip_relocation, ventura:       "ed38d61226779d059833de3031d56e00e8b54072daba0b96ee27c01a3c8581a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "913c42eab9d2518f34a80b726a5c24a30453697bfa6feb83a37c20c124a1ff5e"
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