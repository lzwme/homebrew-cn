class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-02-14T21-36-02Z",
      revision: "00cb58eaf346ca8e8595c1bc50f99ec635db6725"
  version "20240214213602"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e9873cc7040dbaef9db76cfc403e9e1fb46b30502d596c3f5e9fdde4dc0a904"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbe5e7fc63655fa0b1ad6e6b93f9ac8d0c2dee9b4d913ed929e5a1f85fe65a37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "899acaf74c515f53262506ce0e72215efc4957c886db8bd30b3579e23b496fac"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8a560d424e5551d4373807f429f0512168fc43b3b8d2478ab9984b61f75e59a"
    sha256 cellar: :any_skip_relocation, ventura:        "78978a56a47d59446e2b526f205572105cc35cd25245c9ec52e3ee22b76a2537"
    sha256 cellar: :any_skip_relocation, monterey:       "724eb774e074d71cd303e05131584ea202307f8bb85a015a381f05a1dd47ba85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b28543d6ed2946f38a617a2fa3ef8d63404409b14d9e0e6f2475ecf6ef7874d6"
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