class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2025-02-03T21-03-04Z",
      revision: "712fe1a8dfd64bbc3fde1863cbbf55ae17e7c911"
  version "20250203210304"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f2ad63c117130cd6a9490b41ec735a4604e17a06d229b31b0292f67d8e6e6da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d04a3bb2d7aa0c72bc36171566ecfb2952fc5b14a6fd69085c543a6b29c8fc2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50e0dea56c23399a6dbfd9d7fbd2fc76c1b226d57ab1fb8a959b3e441c9b3ffb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cd874dddb9361f549ec05ea0851c3e59e297c2279708dbb16bf72fafdcb495f"
    sha256 cellar: :any_skip_relocation, ventura:       "856e10accdedffe8059eb15398c9efd56c89fc6556040ff65d7beaa801d5f58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be16e804a189721720ff9f448166b05259ac1447624a552917a818128a6ab59e"
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