class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.10.tar.gz"
  sha256 "69212c36d29d2c31b06fac983789b85e187b3a94a80a621affea52f1afce7899"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f87b66f45ee9eb5e444b75a9b6e1aa8431c9907d66fb632390292bdaaf3a6165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f87b66f45ee9eb5e444b75a9b6e1aa8431c9907d66fb632390292bdaaf3a6165"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f87b66f45ee9eb5e444b75a9b6e1aa8431c9907d66fb632390292bdaaf3a6165"
    sha256 cellar: :any_skip_relocation, sonoma:        "da709f137295f390e71e75e32032468c2319fe2486f6d27587e033db7617243e"
    sha256 cellar: :any_skip_relocation, ventura:       "da709f137295f390e71e75e32032468c2319fe2486f6d27587e033db7617243e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7da4047372226f1854e38d33e1d9e55d4f00487728e8c003d78f7ebf3a1f555"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end