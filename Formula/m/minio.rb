class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-12-02T10-51-33Z",
      revision: "a50f26b7f56e5e6b1df8a648423736319ecdabd6"
  version "20231202105133"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f71f2bbec0199ed5cb0a2d76af529cf01d6ca175fa56804eba38c56ed5f9ac63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11cbc4abf7845913304e6de109a419ea946feeef92b40f95ed2f7528522a7e65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a384c5fdcdebbfddb40821335fde6146ae2cf62260dbe818809af9a7ad875cc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c10445b7e259186c8d4b6ce7852a898328357a33c9d6d34fbeaf3242cf57222"
    sha256 cellar: :any_skip_relocation, ventura:        "b659e496232016760f7ba8b6895ac922cd0d2b14f9ba769e91ba87fdf808154d"
    sha256 cellar: :any_skip_relocation, monterey:       "93859cd98be6a03c0eebab55190636146d5e6862423723d6753f87c364f5fb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aedb152244c66665e744154e06e495a4961619250a8db23afeac27c90ba1a5db"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

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