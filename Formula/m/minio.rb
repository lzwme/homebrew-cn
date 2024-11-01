class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-10-29T16-01-48Z",
      revision: "c4239ced225b9fead5f6b44e3665c5ccd7eacc89"
  version "20241029160148"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90965ac115d253e8bbb1084a1ac73d52a81e36fed14e15a0aac03b3cc570a54c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c839283ea2743a7d552466f346b4fa40b128bcf280695d6c8b766c2c3704b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33cbe6703e00c3b0df9d5c2a95fec32b8b6caf04513d5c0002ce40cdf0aa9e29"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b32ac3bba226b7202cdd19530050b3f2d31610155e0d2169ddb8d7cfdcac72a"
    sha256 cellar: :any_skip_relocation, ventura:       "7a50b969d63c0d64af689bfabae1368b84526f36d439d6a0e95d454e631c6b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a55bfd768fec5ddc2fe1ce8a2b6e51145632b52d6b0e7f5216bae9cbd56a32ca"
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