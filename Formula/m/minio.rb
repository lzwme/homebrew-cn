class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-01-18T22-51-28Z",
      revision: "19387cafab76133c2e7642de4aac8c81b9f4f8c7"
  version "20240118225128"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9823c6d4b633c7b472190ae96f7a35c9830e78ab212ba9d1397fce0dcce6185d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc9c2e5cab1cf53025b9dc4310e5211947cd79badafb4d273a7e6e7e15d9b0e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a6ac9a9bf9191d28dfeee7baceaf97f7fb3dad922af73fa374228c847a099a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a50a669c220d3cbdb7f29da8ea6452d8c0c4b0c52f7a2f742b3c43041789334d"
    sha256 cellar: :any_skip_relocation, ventura:        "cf3a5b6758fe61473cc2c303f42818893df7cbbfea5a7cf8525232c1628090fa"
    sha256 cellar: :any_skip_relocation, monterey:       "dd33883ab2c023312fc65f1b4c28cf5640bc34922dc17baf52bf38d3cfaf4cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbbf01698030d56deea220115afeafa06e405fe2cbfa9aab935217b67a9c2882"
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