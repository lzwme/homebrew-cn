class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-04-18T16-45-29Z",
      revision: "3ec030eb26e460ec62655487ba116a05eda3ac99"
  version "20240418164529"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "856e820f92cb0c49b9c566f183ce5bc75d2be0039be8c493e1ab42f7508ab658"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9d5892d2689db2bf1cc42b7a4dede47b1764780d6293ea5756474c1b85edee3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6cfce5ab876db013c8472b21334364683af1ea9f6d68bfa6b69198b4127818f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8856f975a27ef9c06c7dc5f1d36eed7398af9f4dbf50856fa12b87042bac9ef6"
    sha256 cellar: :any_skip_relocation, ventura:        "072f941fcc656181fae537f57f189a033435333723bfb0b552d0b7493827fb57"
    sha256 cellar: :any_skip_relocation, monterey:       "66cf17e086907e7ecdf1406d5d1d77e50fe96fcbbc1442b20975b4cc19fb6860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a79ee41c6a3e8927c3158adda4b17852f7ec271f35221f5c2674e6f4065be9ed"
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