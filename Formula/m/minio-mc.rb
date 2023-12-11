class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-12-07T22-13-17Z",
      revision: "1ba9435365a772d6b4cab225458306a70dfb2309"
  version "20231207221317"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9661632f7a29435f56dcc68ee9139cf8d518e57d5b19f8e7ffbc525f9e928c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85b96cd3b07dffc83e5108f3836ea8600916343c7b63ddb47c3f710e26c0b2a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf2641d0163425980a473cac1a9541fe6b0423915db4994454f3cb0834fae5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6d4ee0ae2d865c506be31f1a9164dde8063200ba5458012e921ea53b83df842"
    sha256 cellar: :any_skip_relocation, ventura:        "69002e2fd57f4b077b3931336428afdbd0603f0fc3a6234432b9d4596ce4d6a8"
    sha256 cellar: :any_skip_relocation, monterey:       "754819ca3fdc08f486bc27225668132bb977dd0cdc6d38bbfd787a60a1a8487f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e08f4682665b7dabba4801ccf4c48c8b8f36d9c6eaa40bf733f348657cd86ac8"
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