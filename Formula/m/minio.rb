class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-11-06T22-26-08Z",
      revision: "754f7a8a395e87a744050476d8b16c16af50a800"
  version "20231106222608"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c27bc0347beca5f8c13bba75e499182785efcbf70a8e2f2618ed4af0b878a2fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb1de3425b3ff35d93cb18662b5117ecafb6ada5250607cfde783af6d57ad4cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "367b728246615c980a281ed9eb9ff10ae38ae1f1b149737c97ed6f286d444710"
    sha256 cellar: :any_skip_relocation, sonoma:         "d027966e9cb93dae46b66b575211dd34cd896026bf725890436162484429f355"
    sha256 cellar: :any_skip_relocation, ventura:        "e0f6fee34b8886f37466d7fbd4913f0d7d48f268d87b134fac0f5dad9f9dfc05"
    sha256 cellar: :any_skip_relocation, monterey:       "35ad59e61c4094575e3585db63c2fa6a7aa0038ad9abb3acdf6d478ec558bb99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd9be0774e5d7962763e7cc24f1ab60f80fcd01375f99a59aacf04bbc04c5b8f"
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