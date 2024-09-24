class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-09-22T00-33-43Z",
      revision: "03e996320ebb887112fb2a15c6f27936e5f124a0"
  version "20240922003343"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a8b30a11078aed529ce590c94282d3e39c47f9cefb87fc21a7381215f7b0ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51d1cef5ab893b1ef95de4de1da3cda3cfa720d40b2a9ae47b2e84ca97336cfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9911eb7851af40a7c7fd64a82d57bb22665a07b11a36b72b780c7fe364284876"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3c49d8da9c1f22fb8c744df6031bf837437d8c2edbcc33f777102ebd51d642b"
    sha256 cellar: :any_skip_relocation, ventura:       "7bd962aa611655b40458144a34ee8e2aad4fe57f9c018378a253510f69bd36fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41d1bd131e5553b058fe2c2a0bfc052b3910821d471af0a69d062c2904f0e76d"
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