class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://ghfast.top/https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0887d9c30b43db30d7386ebd7472ec39a38f3529b0aeda3eff0e619e388e8228"
  license "MIT"
  head "https://github.com/passbolt/go-passbolt-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a8eea0e480998a2eeea959f17a5550e7667dce9ceb93cd2298912f4f9634eab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a8eea0e480998a2eeea959f17a5550e7667dce9ceb93cd2298912f4f9634eab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a8eea0e480998a2eeea959f17a5550e7667dce9ceb93cd2298912f4f9634eab"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9949e5e1def8f6c08e1bea221cb89fa6121d388ef7ac1ab87305bfd5a0e869f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "433f822b5606277fa294935dd7ee3b287c4a87c64cbde14e608465b983ca48fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a587803280444b426c73e47d7b3f60217eef660bcea2b6a57cc202711da00afa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"passbolt")

    generate_completions_from_executable(bin/"passbolt", "completion")
    mkdir "man"
    system bin/"passbolt", "gendoc", "--type", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/passbolt --version")
    assert_match "Error: serverAddress is not defined", shell_output("#{bin}/passbolt list user 2>&1", 1)
  end
end