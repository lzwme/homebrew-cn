class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-01-28T16-23-14Z",
      revision: "ba9fc6a3075df6d8a413cc7e423645706aaefae1"
  version "20240128162314"
  license "AGPL-3.0-or-later"
  head "https:github.comminiomc.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ead3eb898489c74f56bbece65bb7b5a79eb669423a294e60dbbc0af79c841025"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9b5b0872f040e11871fa761baa99f7ba2708afc764e9de91734d52626402db5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d349b099dfa20d091a8c62068777ca06cf623d0cbfd8f590ef5d1170a622db34"
    sha256 cellar: :any_skip_relocation, sonoma:         "63d9c826f8e10c3ff3ed67e522ff95f220dceb02e7277ffae820dc198e5fa48c"
    sha256 cellar: :any_skip_relocation, ventura:        "9771ea72045ce7229077e574c786ac16feebf5c6aa2a8c71c3838f31b1fab1eb"
    sha256 cellar: :any_skip_relocation, monterey:       "092bffd0e3d7393d1e608b25d2ac308587140eec59c0cf7a44864f6b4bb5abd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b680ca5ee8817012ff84f0439b00d20c75bb7c96c156ffe378e9c13f290609cc"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')
      proj = "github.comminiomc"
      ldflags = %W[
        -X #{proj}cmd.Version=#{minio_version}
        -X #{proj}cmd.ReleaseTag=#{minio_release}
        -X #{proj}cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin"mc", ldflags: ldflags)
    end
  end

  test do
    system bin"mc", "mb", testpath"test"
    assert_predicate testpath"test", :exist?
  end
end