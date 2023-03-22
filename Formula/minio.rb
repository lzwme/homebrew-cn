class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-03-20T20-16-18Z",
      revision: "05444a0f6af8389b9bb85280fc31337c556d4300"
  version "20230320201618"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f544a9c401c592630363023cea7de0d25d10a4c4f73ed67dfa2e545b1813031b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "793c2da07728c41fb03befbaeae299a947c210327ee0be0587c4e4a34e041331"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b21451039bb4ae2cf56d4c45d6bd6e63b3667538b440e047deb523c47487050e"
    sha256 cellar: :any_skip_relocation, ventura:        "109108a2a4e32583a560d8590ddabc6f03f4a2e33e47a5ec235dd46deaeb1edd"
    sha256 cellar: :any_skip_relocation, monterey:       "fc7d75d95748f250accbb255218d16f706e17d34a29f44c642de99992226ff0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b49f430da8f9d50f56ef879255065000d7496dc0a871ad7341d800ad9ed98f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37fe6a40e8448a036343b7faa2d9c552b68ab4b341929070d7886b09a0807b6f"
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