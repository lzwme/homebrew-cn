class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-01-13T07-53-03Z",
      revision: "993d96feef0e6b93d963932a66e2a50d3157575e"
  version "20240113075303"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa2cc182edbc6fade7de74e9d91fd65d831472c540c0e9c0b56d2a597267c960"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68f75a1fff02d1ede8cda7a7bc632409d91971e22b7efbaca7d0fbfaca475ab4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d7254bde42c6c7f5e4ea42b90971328337cfdf4812579ec33d8c1883c3955c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8cb722af77394e651dedd58c0cc6eafce411cfce46c288107c8cd71a2679008"
    sha256 cellar: :any_skip_relocation, ventura:        "22b45b91e2df5bb084f407fe7bca4df635e8ed053e4cdc7414e6dd3279efac3a"
    sha256 cellar: :any_skip_relocation, monterey:       "983080c307689b00cf436ac67d512edb0f7b97de3b49c67df8dd2a5ec82e8578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "820afc4f0b67a1323188d5e2fc38376cc063a7725265329e3ab5a75e1594e527"
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
    run [opt_bin"minio", "server", "--config-dir=#{etc}minio", "--address=:9000", var"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logminio.log"
    error_log_path var"logminio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}minio server --help 2>&1")
  end
end