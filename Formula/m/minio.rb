class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-11-11T08-14-41Z",
      revision: "9afdb05bf489921cb97ea87968a0a0c825fc1ec4"
  version "20231111081441"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00e8d74429e2af1a59c07ae974a92bbc80e1f5dc192a5309eea4597b435f1c83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a6a721fdf9cc0d6c7bbe5879e744e4db755cd3d6e8189eb6f1739d4d212dd64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7aa2d48586e39b0eae147e9ce97726be021d0737235c0f88743d0dde3f0a1a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "297143fd1321262f2409dac74536f26d05b536328dd605846603468dbcd5a61d"
    sha256 cellar: :any_skip_relocation, ventura:        "793422677c037ec27caab8469ef2673a2a63e191fa1344e211457c3dbdcc0e14"
    sha256 cellar: :any_skip_relocation, monterey:       "beac2083a67e71c8ac156f4f123464ae5a97cd67a02575a883a64fc858621c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281acb34cf62d19056a0dc460f185164119069885172774ab190c9b6a4f0ac01"
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