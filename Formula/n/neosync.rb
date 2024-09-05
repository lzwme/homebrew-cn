class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.60.tar.gz"
  sha256 "270d4c2964be6e7385c7eb902fac481f0493d97ce55dcbb9f3b490e1a2d4e02f"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82eee9863445f54502727a4fb4f9dd6b8f403d3dcf510633bfa8fa82a60ce001"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "856dba4203485ce4b44dac1623b4990e8e0fba01848b44b70d9a6ba69e8cedcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b9b3065bab35e73c16fc93b33d5c5f0b4d61f4180795f0d4dfb6d4b3cb3412d"
    sha256 cellar: :any_skip_relocation, sonoma:         "638ddc70ca9c9ac988cc95b4f50655c6138c87433d00064460e5bf1173e1b397"
    sha256 cellar: :any_skip_relocation, ventura:        "9aab650ebd1aaa08f39115ddfe34cc9b8cc93a7640d8e834f40049db69249586"
    sha256 cellar: :any_skip_relocation, monterey:       "65bcd8d67f93cb868ebfe9b94fb254a96d5bdb8d7c5994fa089dd496fb7771d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "477c6e6eed39363b6eb258e3df1a54454a29e9390ea1e1949d7db3915c974e8d"
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
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end