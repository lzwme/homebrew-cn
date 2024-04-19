class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.77.0.tar.gz"
  sha256 "2276dbdf25d7201926d7de7b8f9ae1a81c64dd06a6947e0f16e0a16849f6a768"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af28af8272233250865fabf945c709fdd7489eb5289140a386bb1c0f6c82d8cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32913e3117f88e5dad8d7f3145d23d30f6493146ff479753d8f0d862e4410364"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "572e0b953614bd32c528d532b9976c82fdcc59399679acd0a566a59cf7948bf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9542ec9d4d22ce9be906ba5e9dca383650a78cd763391bf0de031b96b9b0015e"
    sha256 cellar: :any_skip_relocation, ventura:        "ca2b6364c6b38c02443f575bf9fe708936b546c6c9a330790a666e827a23776e"
    sha256 cellar: :any_skip_relocation, monterey:       "1e1fa2d397c569383e5e1f7b530843f8e85eee693f8d6a3b1063cee9ca64f809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b55ece52f7334f81defac1fe3553a6eb8e4cf312578209ff65e8070fe448f453"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end