class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.1.tar.gz"
  sha256 "f6d3609f2cbbc2f07b2e755ea3244906af8057397f7dfbf0703298d8d0fddfcf"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "715d0c8fef48f222443c903d1a5a36168d39aac96b3fcf8e4465d23c389b947d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4d155e0ec1e8fad1f6ba08f45c2bd06cdba54b5d288732097747ba1f6fbf89c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8cc648206365a9ce8bff766e606e65af6b34aeabb2bf2d7ff8e9484ca275ed9"
    sha256 cellar: :any_skip_relocation, sonoma:         "69adecf915d093ab7718a53bc2944655488fa73197dde672de47137c2a41cf51"
    sha256 cellar: :any_skip_relocation, ventura:        "218d7e3af750d0360a7eeba53a89773ab77065da337be406c7b8d3e9a6e11bd3"
    sha256 cellar: :any_skip_relocation, monterey:       "7c23981b2e8d1497b2c25fbe08c426a194c42650727846d237652acf8986116c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6daa3aa342f3b876cba668b71fff587acce93d47b15ac14ea218867d06b9c4a8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end