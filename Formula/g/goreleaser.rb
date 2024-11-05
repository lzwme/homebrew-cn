class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.4.3",
      revision: "9a68c54d53d6bca9f1d2ef8ab981fda11a3ef4b5"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68970b283a895178c1833883371a030ecec8caeb3db58d77094b56fea0be925a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68970b283a895178c1833883371a030ecec8caeb3db58d77094b56fea0be925a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68970b283a895178c1833883371a030ecec8caeb3db58d77094b56fea0be925a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dc3024c3431cc0d68b4172e809050bcc4ea9c889e7151b6a28af72acbfa34b4"
    sha256 cellar: :any_skip_relocation, ventura:       "8dc3024c3431cc0d68b4172e809050bcc4ea9c889e7151b6a28af72acbfa34b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d51e143b408c34094e077772a9e644457d5a9c63f13751b28bf2a4085cb4ba7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath".goreleaser.yml", :exist?
  end
end