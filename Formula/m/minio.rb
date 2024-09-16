class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-09-13T20-26-02Z",
      revision: "5bf41aff1702adf2a11fa96a7b68f8651191e24d"
  version "20240913202602"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e54624d256d33d90472ddb44a7e69b244a5abb7bf6521aa6d0327756447a128e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04a40e4728d28b11e5e2d2d756aa5a41d3996ab17f8e7f18c416d31d0f61ad18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72e0a87c543b693c2c5cdceca56b974c16c75f664c9bd38619207896357ab524"
    sha256 cellar: :any_skip_relocation, sonoma:        "66560848447239cfcbafc49d6d0b2872867658aa9858021f8fc6c8ee2f3dafb2"
    sha256 cellar: :any_skip_relocation, ventura:       "b123ef2cc77bff4f13f0adc1f97a01b2d781c08b24f59581f49bdd6279d0d0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c50ce20e55ede74f5026fe8652278a4cde617993d186daee89144642abe3cc1"
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