class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-01-29T03-56-32Z",
      revision: "9987ff570bcea7c26a8faec32910f10f49576d0c"
  version "20240129035632"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3511b945b01bdd747f9f054f027614de84234d4204421f325028b2c70ca6f8ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a111d9b4e1d39faa0f7dd832893943f0a1ac1e0cdcc4e19f10c9f3764b80b83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76cd1cae412f6f37badb4f36d421f98253cc14c49060ba23dbfa9de3821ba1a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "cef74db165b72b293144fbd2d065133d2085fae95bf14e03bc0d33a1fb6dbf97"
    sha256 cellar: :any_skip_relocation, ventura:        "fad1ba536f40b6523c5e967e53527cb7696a79f71c9c08df38ae86a3cbdfa00f"
    sha256 cellar: :any_skip_relocation, monterey:       "56189373846aeb2cedc546419844c71c008d6a163de5e68ad79790eed7b190fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c67e3a455a36abd78bd261a2e9d70ff82c7bf0b331810c52d838e666aa94ced3"
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