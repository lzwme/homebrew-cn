class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-07-22T20-02-49Z",
      revision: "58c42bc91bbab04e4073bd8d018b0420ccb21591"
  version "20240722200249"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07fd76b61fd0524cc0c2514e4f9ece03fb2820da1a8bfdacc495e967c3fd66c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1bff13862602e0c39a8586e8f7fcb2b33d8c22a0b564b004a3ed7abdc1fbc5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e394300be508e5e3f62ecdf1e9135a873e0dfb496ef0ddfd16ee03f983487341"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec4259d4827b139f7970733146888287efb59f57ee6aa636e474d17b301fb26a"
    sha256 cellar: :any_skip_relocation, ventura:        "e231e89d5270df71596e1a893798c6a47ec9169a702d6ca31382f0a28dc1b869"
    sha256 cellar: :any_skip_relocation, monterey:       "c772faa3f56afd44923536e183434742b814b85275d92ca0140880bbe1874e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d7c2932e7b5978aee9ef46d0f6df426e342fc6872b6c703e84bb2cb37dbe47a"
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