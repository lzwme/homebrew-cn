class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-06-29T01-20-47Z",
      revision: "91faaa13877df0e2989b1eb3821f0e82fcbbfe80"
  version "20240629012047"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f53ad3c9ae93a1fd7507405d5c1cd93ef8626ba1dca86f273c1f352abfab9c28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8886dacabf372d536f58bdfa0b1bc50b02761fbe00c4e5da08eb0f0249d0f3a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12f91d00e5aac49031b853154160f07c511d5ccc3f3f95b9aff6507019b37d81"
    sha256 cellar: :any_skip_relocation, sonoma:         "586921e0bc66a12bbd5512f5aa8343aad345fd6f251eb68d13bf49c892977a5a"
    sha256 cellar: :any_skip_relocation, ventura:        "bf8d437b9312a25933b67f8b243b6ae381f9dddcd1751b409d4204db1f766310"
    sha256 cellar: :any_skip_relocation, monterey:       "986cebd9ef132cebc8f5438859c3d9269d45cd5d08fcb54ad5dfa73ad2e7bd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56d4fa0acc462717a56c9ce5269aa0eb6eb4b2e238ef80705822f33433823fd8"
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