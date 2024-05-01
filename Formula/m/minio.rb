class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-04-28T17-53-50Z",
      revision: "a372c6a3779b63df225512263d28019a592886d3"
  version "20240428175350"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "667ddf1916f6276e1800b89f7ec0714957395e1a36499200b0ed2208078ba184"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "675aee5e370ef769249c90eabedeb5605f53d55f3591067fef14cabf37c49887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3906c5c392caf078abb2c8cbae937a6b3c8e2c1105ccefe6a32f8a68e22d13e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbbcd1fcdf8b683c51a509e178f5e7ef9550af59b3c999b60c70cafb70406f8a"
    sha256 cellar: :any_skip_relocation, ventura:        "04402a1d14dd4eb9fc23065f73f38f1390d4edd45526a02667bf07bdecbcaab5"
    sha256 cellar: :any_skip_relocation, monterey:       "136a0eed6ae6b9620b681c39f7dc031b8fa17704d018f91544eed39bf7428da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee518d549790a8de7530c0c981c16bdc027792d3cc0ff0af4b39a2e51d8fe05c"
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