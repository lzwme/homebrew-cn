class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-08-03T04-33-23Z",
      revision: "6efb56851c40da88d1ca15112e2d686a4ecec6b3"
  version "20240803043323"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a08515a19ecf4af22524663aa40d455a14d4e917fa799a0c5fe3ce892a29065"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "065f2a2ca873dc34ea3a103b4f780a1f5bc769005a169bc69fc9368024242278"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60a629c6effd2734b1272efbbc6e8debe6e3fec2525fb27ed10f6f1c26343f70"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a0b1891f4f3b8e3e6431963d1973e2e8679775d31d8106882c970ef8338a34a"
    sha256 cellar: :any_skip_relocation, ventura:        "6c630b949a2d102428c34bae3638cf9e88276b4296f0a5c75896fae77bc048ea"
    sha256 cellar: :any_skip_relocation, monterey:       "e7f82b2222befdf0252f913ca0cd9f0d41770e9f6dbfe38de759c6e28a9c20fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044fd83645470192fda77f586ef48ddca4841dccaff6ea400c4e7f524329d7d9"
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

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var"minio").mkpath
    (etc"minio").mkpath
  end

  service do
    run [opt_bin"minio", "server", "--certs-dir=#{etc}miniocerts", "--address=:9000", var"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logminio.log"
    error_log_path var"logminio.log"
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}minio --version 2>&1")
                   .match((?:RELEASE[._-]?)?([\dTZ-]+))
                   .to_s
                   .gsub([^\d], ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}minio server --help 2>&1")
  end
end