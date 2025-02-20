class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2025-02-18T16-25-55Z",
      revision: "90f5e1e5f62cbc47be6d0a3ca0634bfd84c2248c"
  version "20250218162555"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0cebdbf3891fb08ceaa5aa75bad672861c31a35e9b95a48b5678aeb420d176"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ff8a4e80f658517123ecce57d61870b077e25f515763ca1e63dc484885f5deb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d559a1c87507859dc3c7f26ed404b72c50523dd827bd66275187bcc98dca317b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7f0996013f3740982bc604f460517113a6c0ead31388a0cde49cfc176d4b964"
    sha256 cellar: :any_skip_relocation, ventura:       "05d4ed2aa82be90c78cd891c62564e3745799f9ee8603b249051d7df28ba9fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bdaab894ac4e064a336a96b0fc1d3705934ffe70b1e66a8f23da026fc5cb98a"
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