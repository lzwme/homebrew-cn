class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-10-29T15-34-59Z",
      revision: "9f4659884dd45dca726ba38ee6bfacb2bf776eb8"
  version "20241029153459"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5023633156dbc9c84a39dbacdc5efb5af12f02d7d61dd571cc97821a43bd20c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07f073e0ef814dd88956505d70fdbf7ed2a35f49a4dc6f423f4c473407875d0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68e9f202a52d769e1787039f3785d5da264cc85c2790a433ff6e30e7ed9718bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a65b835b2b0549bb403676038b2f65bca8f7e498711f0089a2b9519ac8e50e19"
    sha256 cellar: :any_skip_relocation, ventura:       "dd3f5a4d691643af4b278e5bff9189988c2c060fc9f25e8d147b70b348618a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f400284a9c3a110cd2aa8b7ec1a158e94c3198e8dd15b90bbfa5a86edc70bea"
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