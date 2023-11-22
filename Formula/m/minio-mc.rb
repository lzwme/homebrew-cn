class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-11-20T16-30-59Z",
      revision: "937b34616f012ad30e1cd6fd61e1da25ff931648"
  version "20231120163059"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ed0956c9b005574fb9d768e11eac5c5b73ca81792d7176e1ac549e3369a4533"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b24b89e08f00a18feafb12e50caa7e77c282d6c3b4c55856aeb54b9f52125d33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf69f8c5a1608ab0f265c76fe7780efa406bbe5803c8fffe0395718a66c31f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f00079c81ce638dfa135a41e0f33013bc5a213062c7dc5ba46d4c0a6a6889c5d"
    sha256 cellar: :any_skip_relocation, ventura:        "6e0a189e5d4f936bcbf0fb455f576269348b09953acfaa015cf0eab02b5e1cee"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb262251d9e897bea46fbe58d7f430e70669ba2a12b57eea1eefa4f4425a3f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "042661c21508faeb2947f8cddbfebf8f8249d1b49b39345d1db29a788879020c"
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