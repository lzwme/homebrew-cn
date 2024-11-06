class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.72.tar.gz"
  sha256 "b67a14c26c7577db9c00a04a1cb6a9311b63f8a5d4d88b40fff3149a437dcdad"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d9fbb7ad336663c1863d92f2648c2187d76619487903eb8fdff50376c7fc288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d9fbb7ad336663c1863d92f2648c2187d76619487903eb8fdff50376c7fc288"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d9fbb7ad336663c1863d92f2648c2187d76619487903eb8fdff50376c7fc288"
    sha256 cellar: :any_skip_relocation, sonoma:        "847ccc07f3becfaed25faf6caa20ab8d43a848fbe026b8996f3a89d8d8c2ccbc"
    sha256 cellar: :any_skip_relocation, ventura:       "eee7c69d0f0bf187f1bbd6b533848ce8be38037f8696586fe66b4e747c0a0683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dffd3fdfc1e024b0cc3aa79771ce42677afbf54d8889d46547b962bb25b1b74"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commindersecminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 3)
    assert_match "No config file present, using default values", output
  end
end