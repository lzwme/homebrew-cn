class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-05-09T17-04-24Z",
      revision: "fdb36acbb1d793b6cca622a55e6292f0d52309f0"
  version "20240509170424"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da3c16bb732da8ad227fa865c2e865a31b8f44d0eef30ecdd6d57568f071e2eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a945231285d714de200cece0b071c02cbe47e069204f5c81d4cd35ef98687d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f592ff2751d2bbc41ae42b12edda7f0da918b1eccd4934e0d859ffe46538126e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8406f285e48c9c0b7262f9bd9f2a3f24fcfcb2531c847531fe5afa34bc5384f5"
    sha256 cellar: :any_skip_relocation, ventura:        "3c4cd3cc9133ba52aa362776a67042108f3899dddaf7181e6af6813d8b07787a"
    sha256 cellar: :any_skip_relocation, monterey:       "5c1b82ae460b58acd8b5eb1982d2dbdfae473d22c43b3db3d3ee1feb2f4e6fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4762ba03baac169c089d757dc263f56917a5a9e50e325ca1c9cecadd034a9c79"
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