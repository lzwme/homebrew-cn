class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-12-18T13-15-44Z",
      revision: "16f8cf1c52f0a77eeb8f7565aaf7f7df12454583"
  version "20241218131544"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3c56ec6775a64c2dc1dcf753e72eaee02aed64c1c2aa07aea7b7f3d7885b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfb24a3400152c454c88144ef9c0626b4a1579b2dedb4c28e6c8cce86ffd4379"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37c1628ad3eba21965d9663fd850d13a6b502e7a765888f6e58968f81544b109"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20c617c97af2384ccc80341f6712c3f14552e63fe68f7cecebcd9eb764d688a"
    sha256 cellar: :any_skip_relocation, ventura:       "c6bf87ddf03412f984106934c11bf72f64c2566bccea707a5fa92428dfdb0837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36c269e905ef0522cabf80a8432ba2fbc87d255a5062bea005893638a6014cc8"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = stable.specs[:tag]
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