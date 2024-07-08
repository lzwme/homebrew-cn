class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-07-03T20-17-25Z",
      revision: "d6ff97012549bfd91396447249297411ccfc79a7"
  version "20240703201725"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6377ddae4454ad748304a23e395a1bf99535b4cb643f40993822672798e9a0c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b705c331242b28c0403790ea2a579be053490761fa6778fb9845617490288a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "242e868dae22f7f0088a3dbf3a48a58efb75d9fa752dee952e9c843c68ea88de"
    sha256 cellar: :any_skip_relocation, sonoma:         "6345d33c8922c1d98f25ecb90c985cefb7e4fc98fbf2a41a47e37c91ae1065bf"
    sha256 cellar: :any_skip_relocation, ventura:        "ea1f03729505864ab79d53e05d3a7018208cb19efd46aa03a25397e30b912692"
    sha256 cellar: :any_skip_relocation, monterey:       "0c6271fe26fadc91e86f578ccfde161178277ebdc230b8e22d41c952dce712b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "158461b998b24503839314916b17bbdc538346ebefd7180c92b35b17ea621f45"
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