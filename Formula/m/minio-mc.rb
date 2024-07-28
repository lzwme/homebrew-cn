class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-07-26T13-08-44Z",
      revision: "8ad22bb69435c831b6a16d4cb03c248145929d95"
  version "20240726130844"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddcbc17c4c54659cbb5c0d2f70f6a56a40b81d63a2a3fb756a6440b7fa40503e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df0b1e418d118f241f341440353ae18ec0c4eddba94af5bfa9f59a49c8f59c86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b68f116bbb94b5121098944c7fe4670e8f2abbb8d0981f1bf26804b2572ca35f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2e07d8274d404217de055fed135b75a493f41dbf4a9c890fa7376a3eb876e10"
    sha256 cellar: :any_skip_relocation, ventura:        "b8b79e47bf0744b99be97e564042592f7b196d9204b8ce7e6635ab43e07dfac5"
    sha256 cellar: :any_skip_relocation, monterey:       "a4cbb5680d1a6b170037f51747e655af2cdceed6835825344115f5401d743232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc46e7937d5e03ca3f519468d9edb40c8935306b070e4dff43c6f52929a5314"
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
      system "go", "build", *std_go_args(output: bin"mc", ldflags:)
    end
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}mc --version 2>&1")
                   .match((?:RELEASE[._-]?)?([\dTZ-]+))
                   .to_s
                   .gsub([^\d], ""),
                 "`version` is incorrect"

    system bin"mc", "mb", testpath"test"
    assert_predicate testpath"test", :exist?
  end
end