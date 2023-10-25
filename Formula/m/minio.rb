class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-10-24T04-42-36Z",
      revision: "2dc917e87f12166e4cfc3b1be24cf2bf70b29bbd"
  version "20231024044236"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f318537261f1fba0560f425a896713d07f7ba1d2ab93df6ca94717233f3280f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32bb0c72438eae336448ad7c4858711634927c81b2b8bff040781b01c8cc74eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c529aad68b77ce23f09e81e9924db7256a976cf25ad9aa11d576dbfe0cd45b47"
    sha256 cellar: :any_skip_relocation, sonoma:         "40b989c9603e5acb49d74a3e0333ed2eff3337dbabde49f4b21683ffbb8b93a1"
    sha256 cellar: :any_skip_relocation, ventura:        "27a1b3d5febfbdb359ad0ad59bba948df10822e359dc93fc6eaadaad5053b7c9"
    sha256 cellar: :any_skip_relocation, monterey:       "92da2c7f33e8fb52a3537be36b8a833910f79385c4b2f63a98beea227bee9533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcaf83a4eb80c37ca0c21b94287b269461dc26aba69e3ea4a071cbe98245ee1e"
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