class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-08-18T21-57-55Z",
      revision: "acc25b8c5057e85dbca855f9d417f13de0603e60"
  version "20230818215755"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2435f02619b75da39b07e23d01d8cc58a522e634e4c4eec97926859b588910c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edef0f12e25d71c16129aa109e62a0defac40b42514297e1fa0a0a7cb6eaf67f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b777e8ea3619c0037edf40995fc91b38c96e537433dc4b6d945e2dc9e4e87978"
    sha256 cellar: :any_skip_relocation, ventura:        "89805e3ae88d355d009ef0e16816861d8376f2d9ba7767de59ab82d18c85594b"
    sha256 cellar: :any_skip_relocation, monterey:       "ef9d04b12dab5b5e494347cbf00304dbbce45ddeae6d9909e1ae80ce5f8443f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "01468c833fb900df34adf80634d6b6f6fb9522c66abddfcd1f3105657531805f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c24c48ded91beb28a2491c9ab6202dbbe134f0f7cf1bf26bcf8557ba61ff21d"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end