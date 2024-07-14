class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-07-11T18-01-28Z",
      revision: "4d498deb35e878efd601dae056f52c6134ddf37f"
  version "20240711180128"
  license "AGPL-3.0-or-later"
  head "https:github.comminiomc.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b49e35739df5bcbeba80350c137952c93638315e2ec883f953e954dea2209dc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c73b9a53b35619447f249f424c61db44944e7caee3bb72366ae690439a2db56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf151e9835a913a48a918ace431d633616a996785f1a7df3f2cdadc81ff209b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "997c4eae3a09aa2c435214d59cfc7c11cc79bb950fc1fad06b8726c753677823"
    sha256 cellar: :any_skip_relocation, ventura:        "50b904497009493e0d3d7308cdfad8e0af6e6d57d0a6faa34e21ad07b0ddb1b0"
    sha256 cellar: :any_skip_relocation, monterey:       "af3559452ac2e5f994b58fddbb0a62a289b86925ff5af5c0279c6dbdb61dde4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae859adcc87a2327a548e278aabcdfd84b5b90f1592e1912980db4cb6560360"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')
      proj = "github.comminiomc"
      ldflags = %W[
        -X #{proj}cmd.Version=#{minio_version}
        -X #{proj}cmd.ReleaseTag=#{minio_release}
        -X #{proj}cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin"mc", ldflags:)
    end
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}mc --version 2>&1")
                   .match((?:RELEASE[._-]?)?([\dTZ-]+))
                   .to_s
                   .gsub([^\d], ""),
                 "`version` is incorrect"

    system bin"mc", "mb", testpath"test"
    assert_predicate testpath"test", :exist?
  end
end