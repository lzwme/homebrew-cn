class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-04-28T18-11-17Z",
      revision: "46d45a6923b5a1813dd9ef18c2fbbf86f0dda906"
  version "20230428181117"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9028695062d463c2785940aa24bbf20d4c380e3dcf31c241eb501c864b38c47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f53c52a6bbc373618abfa320e81f567eb263cc4b11c10955e9b31f93f1d02a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b09d57b019af2d4051c5644fdf229aa7cc2f67be53bccd27a0a4ae25f517b460"
    sha256 cellar: :any_skip_relocation, ventura:        "3b12a825de72144fdec4795259fe731150f722f4dfc6f45bbc96a5fe49250d40"
    sha256 cellar: :any_skip_relocation, monterey:       "5d3663889b1f0be36016d22cac561d6cb0ae200686dbd79580ca50e2ead0cd51"
    sha256 cellar: :any_skip_relocation, big_sur:        "86f3d8ca9e81437347227a1e8c5634f19f8cee71e16a0afeff4701b73e74a9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47c4770d6b021432e1bb17c4de1a647090d8f44599267c1d41462423df29bedb"
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