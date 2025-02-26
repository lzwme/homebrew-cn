class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.25.tar.gz"
  sha256 "e6c1fae88500ad5ef9a3a62cd19f437d8fc40585180c7290605a32b69a1e1355"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99ef3c50ab9203b95d07f4a47b133ba01ad833fab82134c5a21b01b97a48e0d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99ef3c50ab9203b95d07f4a47b133ba01ad833fab82134c5a21b01b97a48e0d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99ef3c50ab9203b95d07f4a47b133ba01ad833fab82134c5a21b01b97a48e0d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a68206d182438d2552828ff1268b2d2d0531fb7e42d16d5ea95b818890c6e974"
    sha256 cellar: :any_skip_relocation, ventura:       "a68206d182438d2552828ff1268b2d2d0531fb7e42d16d5ea95b818890c6e974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e731e3263e74692ebb6b52f8dfebb9856183c92b9bd06c64c65827e15f73abeb"
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