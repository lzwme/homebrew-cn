class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-07-04T14-25-45Z",
      revision: "107d951893c3e02982f200dcbb09d9e953c2b73f"
  version "20240704142545"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13e14e090611ab77be5e1e888e8db0e24a14601c74b0b9788a619d95876b8cbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec9e830d0210cbc1ce0a1ec3ceda4f182e84f929c7321bd31fe9635f8bee3d72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7e02c5755740c37ba74f0d06d6fe69022735011770aba1b1e651e658d728b90"
    sha256 cellar: :any_skip_relocation, sonoma:         "1205fc5b462879ac97070748a1fec905d368755200208ce52d6366bc3475ad96"
    sha256 cellar: :any_skip_relocation, ventura:        "124bbd754e265615944b7b4f473e44139179e725ea3278bb3b0df8100cf1ab19"
    sha256 cellar: :any_skip_relocation, monterey:       "d025376351db303128f0adafa085ab0b4b677b1cf5b90affba41fbaf37cbcfff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fc478b4ea93351c9d38d0386695848a05ec513d2fc27111a70ba459844a0ff4"
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