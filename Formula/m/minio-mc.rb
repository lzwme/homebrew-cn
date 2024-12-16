class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-11-21T17-21-54Z",
      revision: "1681e4497c09d7438a34e846f76dbde972ab7daf"
  version "20241121172154"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fc4c5b530176917dff615e2f1b13bebea7ab9112e704a599675f2b114bd16c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dcc23f7b6ed505f879f21eee1f24eea84848ac567b6499602af1dfe8858eac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa78f11dd087c1f728d84a07c6f923d727f69f5e81490e68499d094cd756dec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2539f80ad8e1520c1a4c1861a8af51dad9f3b3fe27312695ab31fa0d691d4a29"
    sha256 cellar: :any_skip_relocation, ventura:       "7b77723e966d20ccdb8990beb27d790065a9c380256cf64d4e9d70ec6385845c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebac51e5eca4fd99ec989bb8f80e4072c0b5e66ab7258997bb32ea7af795f94d"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')
      proj = "github.comminiomc"

      ldflags = %W[
        -s -w
        -X #{proj}cmd.Version=#{minio_version}
        -X #{proj}cmd.ReleaseTag=#{minio_release}
        -X #{proj}cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin"mc")
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