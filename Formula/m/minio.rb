class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-01-01T16-36-33Z",
      revision: "8f13c8c3bfee304e11a56076039f13e343937124"
  version "20240101163633"
  license "AGPL-3.0-or-later"
  head "https:github.comminiominio.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07d7084141b03c525a2c1e39cf5f8175a16990010376bf0288c902818c52f8f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9efeb6d740f6e49fdf2fcbe664bcdc6cc8960fcebada7397e3914c984b0ccdb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94ee97766d137c36380581339c8d378d196b91e9c6ac7a13210149e6ec903c83"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e909a900beae6ea4c2e75e79732c9376b82a7f224105ad19cd751446d63fce1"
    sha256 cellar: :any_skip_relocation, ventura:        "8317ba8b9d31e924d8c2543bd08c3b9c6c3deefab1fa69290ec146788e9328e9"
    sha256 cellar: :any_skip_relocation, monterey:       "5ffcb57f580aca892cd65246d906151ce4a12ed5f0fee33cdafcc445fd2ef0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28714416ca47a79765f1eba06cb70dc8d58d7fbc8bcfed21084dd1166b431dec"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.comminiominiocmd.Version=#{version}
        -X github.comminiominiocmd.ReleaseTag=#{release}
        -X github.comminiominiocmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var"minio").mkpath
    (etc"minio").mkpath
  end

  service do
    run [opt_bin"minio", "server", "--config-dir=#{etc}minio", "--address=:9000", var"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logminio.log"
    error_log_path var"logminio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}minio server --help 2>&1")
  end
end