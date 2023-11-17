class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-11-15T22-45-58Z",
      revision: "4724c024c6de8bf2f072821ec85a19ef7e9b49d5"
  version "20231115224558"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0c96ab3fb01704c5dd5a3390887772f258f6ffaafc5245424b95c02becc9b58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2307df100db1054cb045f0d51e8e53508c40bc03226a56b24ba3c7ff5f78c384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e75666080140a672a085bbab9d6cf7cda736c68b983bf7c13983138d98815b5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "335be9e0c61d6c3bac583235908f64542c3794412067ec7fb49764d234aacea2"
    sha256 cellar: :any_skip_relocation, ventura:        "f56c8c8aa4d5b50c533655582cf2c334a14e942101088b3f76b32fc4d7d5ec3c"
    sha256 cellar: :any_skip_relocation, monterey:       "fda4dd9dbcd6cfbbaca8a8a2cc3853a2a34b19b32d88d7773acee3e83527590f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a50b1711ea40a27118f175eba19a14903f318a941528e22d2cb36b303704b1e"
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