class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-08-29T01-40-52Z",
      revision: "504e52b45e8350d0b64ae52f4b4307fd5d6b23d1"
  version "20240829014052"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2649bd56ef2da88610b955a6b295e86f3ba7606c839227a68d1aa2de639a12af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fb1315e515ea07409cb79caab25282ef26f0131307dc73f84a668a00995ff7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21002372a82bf98e6078e851207e95c96179811a4f90f1c320baf84995d8fd45"
    sha256 cellar: :any_skip_relocation, sonoma:         "351218e96ff5aaa45d12bf9228f1ed0c225a421c584ccc652f0deeb306c7c972"
    sha256 cellar: :any_skip_relocation, ventura:        "26a8abc54e8c1ca7b75106b404a87193cb1bc30ce9747116c4df05151b528b41"
    sha256 cellar: :any_skip_relocation, monterey:       "903b9457b5a8d57d588013d42ba185fc6ff15a62a10e027ff9a6d8bb25f6b695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d831b3798fd415cb06193d3194bf43898a9d766058806bfd31b260c89221a3a6"
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