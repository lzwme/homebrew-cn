class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-09-27T15-22-50Z",
      revision: "3c470a6b8babc803a2d79e45cccfc806e57a2709"
  version "20230927152250"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fbe153c20d8b386507a2e05ea487d58192d93da2a5121c904bb66d7bda6303e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd82aedffc26617f7307f009d23429284dde839cb402045b647bf1ed50c4cf98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73d2b2b11f333ac552ef0758d0af5fcff69c73d7d07ef70fc7e04daf95a3cfec"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b8b35008b43b38527204aa7a096bc79dd42e88439e9023848dba24801a1a711"
    sha256 cellar: :any_skip_relocation, ventura:        "7f0fc6ec520447183b7db976934a539ee8b911e860b3ab131a562a208c11f738"
    sha256 cellar: :any_skip_relocation, monterey:       "4880e83b967d05397765c9c9c813124b8b2c3cdb4647b4628b77c3a751ea8da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43c7d3117c653d2dfd39552371a0d59f474afd96f7885c2bef7f8df5e2b475ba"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end