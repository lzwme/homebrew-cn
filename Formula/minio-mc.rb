class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-08-01T23-30-57Z",
      revision: "0a529d5e642f1a50a74b256c683be453e26bf7e9"
  version "20230801233057"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38668e12d4c06a1d5f2218b684879d5d9804266be1e252720b24dbf21dad4251"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d10aa4670ab7cd642af802b86ecd4b75280780fcec879c594bd251f31a5a8dee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47fd9734cd30936249c1f13bef8d338775a0961679859ca1aa8394f967f78dd2"
    sha256 cellar: :any_skip_relocation, ventura:        "a6cbfcfbf05ee32e078c967e52786bd0c4a4efe93bd187327a70870031800ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "f8cef4f836ff628a1bdaed6e39ea39b5988168b516cf3fd3fc8fc6ca9478662e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4ea2eb6a596d54c540ea2813490eb1154bf0cf700435a0605f1d3e769d083ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d25fffb3c79803b75326ce14a332af131267a8c0aabf58202d061d3f048144"
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