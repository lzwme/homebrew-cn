class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-06-10T16-44-15Z",
      revision: "7a0a8f54d901fe3ee7b8854347025f54ce3ebbfc"
  version "20240610164415"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd5fb6e0230d152b155a671118765ca23e79d68f1c6a259a65a56b79222cef6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15aad1cd6ecd92f9ed2e57f29377604896be0b02fe7ba371123ad2bb0622112f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5096982ad6cdf88ca7efbd6e4155392ca1d2c3b8456cde1c10773af4e411c59f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e0583a5006651f73b1a8d6c2d2329ab3a5dbfb8312ad6b4f42f89468a556503"
    sha256 cellar: :any_skip_relocation, ventura:        "1b9682534e6204bd2059ae3e239a758750fbf801c6f9bbe44fe1f7defa06b4f6"
    sha256 cellar: :any_skip_relocation, monterey:       "87c1bc0157998761facbccab59779249778d6f0d468ee16d75f26ef6dee86684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2fee030389c6d60581a12ec992a55116192bbb9110a7c5d49c7119b6833968"
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