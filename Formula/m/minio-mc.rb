class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2025-02-15T10-36-16Z",
      revision: "383560b1c3d6912042e8c8c275bb78e83e67ef2b"
  version "20250215103616"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b554a914ee6a583ae19a5eb500c32c528bf834847500ec629e9bb62c9980f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a9fb0558fe7ecd8b810e6bd1797351e455c1bef6cd2147de47bee0f92982f35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9b2c70af898c7be0352c92ae03511abb949d105b609dad079ce63c063a4d085"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0dd0a8183f30edc86a8b736e6c0aef59461b2ced97da97578cba7f57d06bb68"
    sha256 cellar: :any_skip_relocation, ventura:       "01ffa1d64968f3ebb87cee8b80d3452f855997e6e594da6e4fa5ba28338536cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa609e0ad31c6381995d7120941780b3b0d15a24a710d01b5ffd882fdeedb488"
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
    assert_path_exists testpath"test"
  end
end