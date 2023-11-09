class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-11-06T04-19-23Z",
      revision: "011c61b2547e9db988262f9ef12c64e981c42705"
  version "20231106041923"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af2f9970a16717f91f1c95c8a792d56766d876e34881589372537031ccb46754"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e68481ddb1fa198d7e6f9bab15a4cf6c8931fa7113977d7e8139065bfbf364e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "524fc4eb2b21adaf9d5da7868fbc1d438a4134c828be83af7f554d061a6e6fc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3132fcce0421c1f0daff9d18285bc28acd95f312aa857d52269160e385f8065"
    sha256 cellar: :any_skip_relocation, ventura:        "8a53d3a8d69fdfd02e40e586236905d32bc80f9e66fbc353f8a9e0961b19aba7"
    sha256 cellar: :any_skip_relocation, monterey:       "03d972ce19de25d20f849dfc8660c1bd2e9c0f837578d9991af8c0e22b016a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ffcdbffd8006fe735d083666578f33b2539c0cc749cbb240ee716cdc7536a7c"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end