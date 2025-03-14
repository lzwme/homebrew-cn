class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https:aquaproj.github.io"
  url "https:github.comaquaprojaquaarchiverefstagsv2.45.1.tar.gz"
  sha256 "1d3300c389eef5992f13f0d05f69e83fd9be7f8f866542174ec73d8f519bd4f5"
  license "MIT"
  head "https:github.comaquaprojaqua.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d6189b2bb18b722626d22ece74dcf42e1b3efd2a362ac98b09dd0b521d6dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d6189b2bb18b722626d22ece74dcf42e1b3efd2a362ac98b09dd0b521d6dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84d6189b2bb18b722626d22ece74dcf42e1b3efd2a362ac98b09dd0b521d6dda"
    sha256 cellar: :any_skip_relocation, sonoma:        "76d12eb2dbedc4a146eb7bf3e08731acc5d68ba0dcb84732c0665a457acc8d1c"
    sha256 cellar: :any_skip_relocation, ventura:       "76d12eb2dbedc4a146eb7bf3e08731acc5d68ba0dcb84732c0665a457acc8d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01297649f413294336070bf41a6dc35bf435b1b398a495f6fbd38d41eac30ba3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdaqua"

    generate_completions_from_executable(bin"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aqua version")

    system bin"aqua", "init"
    assert_match "depName=aquaprojaqua-registry", (testpath"aqua.yaml").read
  end
end