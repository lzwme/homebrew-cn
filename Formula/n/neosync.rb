class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.83.tar.gz"
  sha256 "638bc86c17aa33847a4cef6234e5462a35c3d142766b2dd0a4919304bc87081f"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f6678f3abe66efcc424be812359796c45e243d7bd8c0017781bf042e47db1ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f6678f3abe66efcc424be812359796c45e243d7bd8c0017781bf042e47db1ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f6678f3abe66efcc424be812359796c45e243d7bd8c0017781bf042e47db1ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "3758d77834ee737ad1c246f0a4e958407cbedfca71aab277097a7a0d30f449f2"
    sha256 cellar: :any_skip_relocation, ventura:       "3758d77834ee737ad1c246f0a4e958407cbedfca71aab277097a7a0d30f449f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad43b2a51bb24427c2aa00b8d76c1cc1ab28c75633e32c2148b3c8af165a71d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "ERRO Unable to retrieve account id", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end