class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-07-21T21-12-44Z",
      revision: "d004c4538643eb05ea69b919557d5cf7cc332fae"
  version "20230721211244"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ed8e80df323ff8a92b17ecbfff11ea0e0f88ffdeb46cb17b3b7b37f4598455f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e068d483e3c0728e4c11aa30dd36f3e2346211c35ed0dc504a43fde15612ad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c3a86b5919806f4e3ffdeffee4a387dcb09ff7d4ead13a8af4dc5ef8c656a50"
    sha256 cellar: :any_skip_relocation, ventura:        "624cd754afbf20ed279bf60674e97380014548445a31075cac9078d540de1367"
    sha256 cellar: :any_skip_relocation, monterey:       "66f94e0c597032bd0aa3dacbc8e49f1f3901703780ae62b94f45b65e8e93d6a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a434285272a6b1297c48af5bc212a3e8015f3b362e77efc19eb5a00a204a8acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "730ccf89676053cf43f52ed955d2b4fc75650c0ec758a1f41d125097fdf387a5"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end