class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-09-09T07-53-10Z",
      revision: "04c5116c9bdf8b762acc54b5500a9a276a5ec05a"
  version "20240909075310"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e9a18ee0818608cb2976023ab0edcf83ba8123dfc2db2de2069206efd2d05218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a067bede277bee36eb257204b15f3c296d53d61055294e8706992a07812baa09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4de4aee3798c0403865d20cb9a23625b66ccac9a9477c84dbed58332eb36b7ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc31b3b44b0dace9fa1ff14bba006f6d4d947be77de31970d7ced7728c0b196d"
    sha256 cellar: :any_skip_relocation, sonoma:         "76c6d2f5ee5c90877d852b88c0a77b527106e81025e67099e813b3e8933cce2f"
    sha256 cellar: :any_skip_relocation, ventura:        "b8b1487fab7c05d93b0aeb73c556b3699c78517700a97fc2124167829bbec5cc"
    sha256 cellar: :any_skip_relocation, monterey:       "8f2305380091e0be986942a44e16b5ef06124457d74f6c58eec2427b8cb8826a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27bc8b3f132e9e09ccf2b313aad8553697a90385787c54a7970969ea582ee312"
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