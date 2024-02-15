class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-02-13T15-35-11Z",
      revision: "7b9f9e0628f4e697e9242b77e80afe1afaf7a4f5"
  version "20240213153511"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b62ea695a96c3e227a4047aff50931b136ed5fe08a43fc1008552b08d44f436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ed3e6e3efa25d538e2da8e945420e50275b195c9e51f0c998f81b7648c5a85e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2122da258b021bf235bd90183919461198418642ca6fc86d00eb9a331b0c522"
    sha256 cellar: :any_skip_relocation, sonoma:         "06fa6942d58cdbb7c4f374d9cdad07a4dafb3c171643ea045635da21b3c27afe"
    sha256 cellar: :any_skip_relocation, ventura:        "bf85b0592c8bf2a62780a63eaf696a5342123b5f602bf1c0174d637642e152a0"
    sha256 cellar: :any_skip_relocation, monterey:       "ede7fec9c0b1309eebd76e04635f18e0df112eda057434f8f38794879ec417cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aef83781cb8bcc2709e2adc98c5defcab0d9c0af797235095c972cb345c1ec6"
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