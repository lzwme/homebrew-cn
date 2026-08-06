class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "f2f78c3a19dde3e908814ea96b3ec18c841b67196f834ffc01ee1ddcf01efdff"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afdfbe652ed433a983ee89a70660f5808fda00c34605b9f22591cb4dd1601b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd898fc30eeaab5a340c08e3b0c39e6436e7762f9a1323781ef3fe2d8200894a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a09a7a1a2e618067758078ecbe826b52dcf88cf8d45f5c0be72f28ac82cf5d10"
    sha256 cellar: :any_skip_relocation, sonoma:        "54ac77fa9a68de32ffd3b809bf555c647cfc3ccf965827fe8c4b00f219368991"
    sha256 cellar: :any,                 arm64_linux:   "082c547eb900507b9dddb0b57e33f377726051351a86ee7bb6496381e86492cc"
    sha256 cellar: :any,                 x86_64_linux:  "d82cd3bf9e7faf9406a7ce22a2087d2589dfd3bc18e8c0ed7690f4f08aa37d0e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end