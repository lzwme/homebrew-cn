class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-08-09T23-30-22Z",
      revision: "eb55034dfe5ef82449796c83e3126b245c5aee05"
  version "20230809233022"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebef7562ab69d257b5349b9b5a4222eb8db81b5c6bb3789f98934d0db42ff3e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b49d4b6e167d7eac1badd3e2f35352bb05965e0b2cc8496a8b2b415e3265c9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2c766b7c5e69f3fa6dd810fb4becf7b1b810bc754bdbb0e721da830428d8181"
    sha256 cellar: :any_skip_relocation, ventura:        "195a71143b8eac244659e40047c675634380a75df64fc5eb83765fa4755e5dc4"
    sha256 cellar: :any_skip_relocation, monterey:       "5a2ab9935492c432255f956da210f759f163bb2bfb574542c013d792cac2dae0"
    sha256 cellar: :any_skip_relocation, big_sur:        "58f1530c251f1f7749957d31de4fdee1ba611d4e9ab3dc570131351e01682f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "002a04141e5920fc1e01281aff4b4e3e3dfe33994691ec116ebde564d0c4956f"
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