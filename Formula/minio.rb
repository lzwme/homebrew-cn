class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-03-09T23-16-13Z",
      revision: "5c087bdcad7ec1042e452ad8af43eede32e15a1b"
  version "20230309231613"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71d90aa69a7bb0c152f2cbeb4a26ba601bf6a79baa2c50b5e741b03b8c660de2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "877b436c97f534c617649872b1118f17e87f88b7c633107f7cac3c7cdd2e8f73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ea7de16449eac958d2d6e4ac61f392c1604bf0506107997fdc3f971490d03fc"
    sha256 cellar: :any_skip_relocation, ventura:        "7e79cef52b1d7a831f0123180eec3bf99e1226175cd6f183ce4d8719decc2212"
    sha256 cellar: :any_skip_relocation, monterey:       "43a6f89293ae33d2dee79b32abfb9924a0e225353bf28bbbad4f0387b4fa462e"
    sha256 cellar: :any_skip_relocation, big_sur:        "031122ef9b620d1d705fc1bd54cd4f89b8941f317aabc2fdd2d154d0233099c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ef264031714cfc483a10db69bda4c6f1a06c4088c201c0f6f5747503756d8f1"
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