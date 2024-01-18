class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-01-16T16-07-38Z",
      revision: "ca258c04cb1dea33c31fed86250eaa3d1f020ff8"
  version "20240116160738"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f21248d4dbb8c610836a89683a72e0829c8087eb1df6df47fa8c21e9d0ea149c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "421e676d38f48d933ec20b8f8b39ecc9480fd2d8ba585ab59465b3de9290fbd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba493925f4f119051aadb092a3d109c2d577a4863932e96a8e38b4d36dac6f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6915dcd4193765f33d7cb02770814cb1435699205673a3b44359a3203eb70d5f"
    sha256 cellar: :any_skip_relocation, ventura:        "1b3ffbd493ab5ff8c5c9497ae78a0c86c47c460b869ba349df7eb14af005e294"
    sha256 cellar: :any_skip_relocation, monterey:       "2736da97d2df014dbea80a5c82e18f9e419853793be86bf450bb10c9d5b19287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac15155b0ddba7fbc962ea5b5065c93aa8a5b55c56dc58f9c3bfbbbfc05c46d2"
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