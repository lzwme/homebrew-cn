class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-10-25T06-33-25Z",
      revision: "c60f54e5be7302d82d0d8fc404c056fea4e2bf4e"
  version "20231025063325"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c15afe5f0110976d69f2bd9d97bfcbc54b5aed997738efe0c74636112ef7f40a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "535079dae8e91c733992bb11a4855a0b33992c19aee4a191c0ccf17a66d0bc1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38b8363db99ef62431e01cfaf8c40d615ca4a8e12543899adcd2bf7ee6258443"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb79508142e188fe767a5a876201c5123ca9d58fabb6604083cc688c23956335"
    sha256 cellar: :any_skip_relocation, ventura:        "59e431a55039a06642addcc03993e5770dd603db8f312b18f5eda8c6fbde222f"
    sha256 cellar: :any_skip_relocation, monterey:       "a8912393f23d00bfef302fe15f5c0e02988ec5d672c731179f932d7918d16b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0dec4094f7cbeecd2c05118be002e74e5ce46ef62e3a4865e7b05e1f12f4483"
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