class TelegramDownloader < Formula
  desc "Telegram Messenger downloadertools written in Golang"
  homepage "https:docs.iyear.metdl"
  url "https:github.comiyeartdlarchiverefstagsv0.18.3.tar.gz"
  sha256 "24dda392d0ff96b9ac3e16ed38169f8b5d0697ecc80e6d83809633b19d5f91fc"
  license "AGPL-3.0-only"
  head "https:github.comiyeartdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75e53b51e32df12e43b503fa106aa6e766e11fb7122d56efd8c1bf8643638ed1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "487d7dd18bcfc429898fa194b97451dd6d7982b88dba4fbd451fcdd63a1afb81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e12be804be7fbfb094952c718dc8db8d23606c951d6daa3420b62212b21fd742"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b0a641032e96e78ff489fc9e1ac96ac8668d6f6b9b2308f67a0971e9967605b"
    sha256 cellar: :any_skip_relocation, ventura:       "8dab873e8bfde1113d022891753a959611b37aaaeab2a6e0179a58fa39487443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7bb1a06deadc61ca364d4fcca0120e481d7676f1b8d9d6904f1f93e215e7090"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comiyeartdlpkgconsts.Version=#{version}
      -X github.comiyeartdlpkgconsts.Commit=#{tap.user}
      -X github.comiyeartdlpkgconsts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"tdl")

    generate_completions_from_executable(bin"tdl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}tdl chat ls -n _test", 1)
  end
end