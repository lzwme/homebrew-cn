class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-10-07T15-07-38Z",
      revision: "c27d0583d4d496981140eff822e2abb34a6f0b60"
  version "20231007150738"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11f01858949233a904926243281eaf90ad6ee0bed04b970a820e4d3d69072756"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1108de9e01d7d2057a2c6867de7e7911177289fd9f2eac9ca175e5c64a21370"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfee12091963976fe05c6f2d1b2f45b98340382c495339b59a3910d0bd51b2e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c15a9d2a1f6fe07d29afcc221e01d94c878a6cd96e6f15e9b3c37d02ec601a3"
    sha256 cellar: :any_skip_relocation, ventura:        "8d13b73f2e5de8c6c19c7d876ba2a03cd43e482c6f4c7676aba6caab25a55542"
    sha256 cellar: :any_skip_relocation, monterey:       "8a16f1b299610dab5c96e03960b5f8a842dfbe055aaac732e3c7398613a5e593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f275a3cdc6ae52b725a60e02654cef4bf4efd399202cbae9f63a04e392874f"
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