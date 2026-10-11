class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.31.5.tar.gz"
  sha256 "30f86f4fd9b5838ad146d8b3ac7495cfc86b89bb619d206a794945b4f3da052c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7e378b64e4b15489645d9e48984fe36b43db0494328aea1cd11dfa6adea6460"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af2a438adf54b432147bfda4d462aaee304f5f4d01295ec4ab9de10329be08e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd1088b4da49e8131c3d4e3251e90805d9593678fc587b4da96062b32fe05b54"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2af45eef1b0c31cbd693683f2f73e4de593883422d2eeb4fb569bdcc40b8b97e"
    sha256 cellar: :any,                 x86_64_linux:      "147c5f6cbf2092ea8a1441778b2c96ad120a0eea8866100c76290a8c52ee23dc"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # `mailpit version` in the `test do` block checks GitHub for updates
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "--offline", "run", "build"

    ldflags = "-X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"mailpit"
    keep_alive true
    log_path var/"log/mailpit.log"
    error_log_path var/"log/mailpit.log"
  end

  test do
    test_email = "wrong format message"

    output = pipe_output("#{bin}/mailpit sendmail 2>&1", test_email, 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end