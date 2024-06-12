class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-06-11T03-13-30Z",
      revision: "55aa431578ddc6c9b57b873bf39ebe9d3ee10239"
  version "20240611031330"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e3ac1059a1e855c8809332050082447cd786d21c87c20c2d2358f4ba6dec900"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "302ac384767f96c77101e3d52dba5fc545dc853015b971a77aab58d0a585bfa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfb0df83a63d0e074a4d5f9dbb7c451b5f36dfa1402a8a588f05793da0315bec"
    sha256 cellar: :any_skip_relocation, sonoma:         "3752f873df88a2270c85eb5c9e9ca06a7360b0be1e360e27ee56f2b06cc5d095"
    sha256 cellar: :any_skip_relocation, ventura:        "db717304fe7f4e60cbc1aa59e08b32c2be18ad58ef0f5c1d6be7585912db1393"
    sha256 cellar: :any_skip_relocation, monterey:       "f2723f061dd3777e90209122abdbd5d18ca4440cc6371c971b35b28302bb39d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1344df3412c4a7afbd9debcc73d97ef6371ebbe8f6fe690f1978e7880b10eb67"
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