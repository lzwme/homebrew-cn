class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-05-27T05-56-19Z",
      revision: "394690dcfb1b80532d5785bbf5313a0e57b58a00"
  version "20230527055619"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1bd8a6ee694dbf357d967b160d718925ea50d2da4af4d1c848a73202c7d0961"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "853d523d9207306ae24f591c50e411454662c2d96d24ccb36bad08a98449eb0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfc85a362fe9df9d094d0e6ac77f71d1a3374473156ebefc634936989091fa38"
    sha256 cellar: :any_skip_relocation, ventura:        "f7e87a37193a12a40d13e8ee0c15b6fbc1a003f21be4a49217d3819c361ec83e"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf40954505a76a5669170a62f69f15f6dd027c155ca0bf50b972eb2ead07e3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa2ef91a81cb9d951e222dd781dbdd6e652518b66314459aef6f93d3b5d351ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a53b7cfba185e41561dfb61e53b4932d136d028d2e2ef50603289c1a36341cea"
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