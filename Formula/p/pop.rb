class Pop < Formula
  desc "Send emails from your terminal"
  homepage "https://github.com/charmbracelet/pop"
  url "https://ghfast.top/https://github.com/charmbracelet/pop/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "7f95a631ad84af09c9ba076348db92f4af5428087c3d03f6fc828b4c1c0084c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad6867f02fbd078db70ca3e9d0ad9a1cf898cfc5902c856974881f98be4b73b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad6867f02fbd078db70ca3e9d0ad9a1cf898cfc5902c856974881f98be4b73b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad6867f02fbd078db70ca3e9d0ad9a1cf898cfc5902c856974881f98be4b73b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d93db3b51ad72d659059e42b9f601f859315e024198b345c9c09c4118c1bb9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "475f0a5e99e18179d93990a2ff2357921874264e85f9be96c5d4962c9da116d7"
    sha256 cellar: :any,                 x86_64_linux:  "1dc73545affea029e10ca4dc13a56fcefef922b2b4c5dcb3cdf11741bcd15580"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pop", shell_parameter_format: :cobra)
    (man1/"pop.1").write Utils.safe_popen_read(bin/"pop", "man")
  end

  test do
    assert_match "environment variable is required",
      shell_output("#{bin}/pop --body 'hi' --subject 'Hello'", 1).chomp

    assert_match version.to_s, shell_output("#{bin}/pop --version")
  end
end