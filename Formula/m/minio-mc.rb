class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-11-17T19-35-25Z",
      revision: "bb4ff4951a3e54bbee6ac75cfaf387c521e98709"
  version "20241117193525"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3071ab2e5e0082dfa4981b679d6babe87689561453480513e6bca27f0e5e0f90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f307153c106c229f622766849175626ec17dab2fce7baab87b571f9a51be354"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aeed72424004c90af9c9e258b792cc9afd75b3331730a8eee7611005c53aa18b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ffa62bc2e4d0f24efb1509791d9c458ee3ef1c2dce442e1014eb8f5fd0c7571"
    sha256 cellar: :any_skip_relocation, ventura:       "2d3bd6c672eb2ce8fc59d7063d1dd90ceb228b815cfa094508aaa8cd3ffe270d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f125ef044ad736eeb4979671288d4ae793f9cf631cc4ef7d445fe8ddd38a750c"
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
      system "go", "build", *std_go_args(ldflags:, output: bin"mc")
    end

    generate_completions_from_executable(bin"mc", "--autocompletion", base_name: "mc")
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