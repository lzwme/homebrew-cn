class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-01-05T22-17-24Z",
      revision: "04135fa6cdd68e281094f54eb6edb901059789d0"
  version "20240105221724"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c66c700936ca1c4dc05c5fe5dcc8bd981368877227ee354c252cb3333671cff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3933da74e17700a797d437740c24017ccc6c77177a6e65508603c247e22e97cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f46e672d3dd4c5a9c5d707b090c28c67475d745dbc75d2742c25c6cb305b1f17"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ebed689a85178e6fa9061ae1685cfb19ef0b5abd5b2e81660dfb07361554e3a"
    sha256 cellar: :any_skip_relocation, ventura:        "089b608b74a09fb08a03433d426e9917055e43434e1b6bac123423677ae010a4"
    sha256 cellar: :any_skip_relocation, monterey:       "d958fe6ecd734926274fcf4044b5a421b5a9497662a4aa746e2b136c8b3cd6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b2f7f64e44b246611efa45d48d1b59513ef599e26d4ba9ad9925d7f8a901e26"
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