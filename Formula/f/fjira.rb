class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://ghfast.top/https://github.com/mk-5/fjira/archive/refs/tags/1.4.10.tar.gz"
  sha256 "a47e726d56322ea17e77ffb93c98f00656e6c69571de7ae51c662296ba1d3fd5"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9140376c2d88c3b62f7021c5e3b9ab1d50e1ba02f4bc3c4b5789aeae33422d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9140376c2d88c3b62f7021c5e3b9ab1d50e1ba02f4bc3c4b5789aeae33422d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9140376c2d88c3b62f7021c5e3b9ab1d50e1ba02f4bc3c4b5789aeae33422d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeef72e7b13d81bee808c9224748aa2d96ba920398be57554c2f924c11ce924d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53c2c9d34a05c46745f6a39e441bf03942e4c77bb3f404bf006afcc8e1c07f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abbbf7c9e47f75f0ef543ddeddcd6a617be2b49b482d0bff4580a6992acaa071"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fjira-cli"

    generate_completions_from_executable(bin/"fjira", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fjira version")

    output_log = testpath/"output.log"
    pid = spawn bin/"fjira", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Create new workspace default", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end