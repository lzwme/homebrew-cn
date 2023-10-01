class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-09-29T16-41-22Z",
      revision: "d47a2ba53a5e10cd1bc8b946c05f4cadb71d4ee3"
  version "20230929164122"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc26f15895f1b3b8f758f154d88d62aee973e28489f0f79016c02b38376aef65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38c8e96f3a40a1bdb7dd214d421ac492de53080bc0bdbf9c9252b4f31ef991ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e89666202b931bf03c64a61af9ccd2e6c71914dba199626603d880599fde5fe7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5d5a3d7bc0c2a389ef4a78a9e093702e54863e937b91f584a3ce36e6f722eb0"
    sha256 cellar: :any_skip_relocation, ventura:        "a539bbe03a89c924e59f2033ee802683fadf2bbb3e07d72547f61416ec75ae11"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c9ecd726752c8fa41f523e09b672e4e017c758a3bba5cfd22c9a6e4f1a6b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae85da4a5a06d4d3f6eafd976029ecd4cb64e98dee98b93d574949f257e2570f"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end