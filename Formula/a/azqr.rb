class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  url "https:github.comAzureazqr.git",
      tag:      "v.2.0.5",
      revision: "58b11ac2cecfdb42eb46e88736129833a6c80f02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b9a7559575beec4397f6dfb1f2fb8cdf2b32e7b7079ace48a099a7d5d019151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b9a7559575beec4397f6dfb1f2fb8cdf2b32e7b7079ace48a099a7d5d019151"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b9a7559575beec4397f6dfb1f2fb8cdf2b32e7b7079ace48a099a7d5d019151"
    sha256 cellar: :any_skip_relocation, sonoma:        "58bebfd4f1dd688286fab4c160134f5f8443fe67d7b6a48e3c7b6d219aa7c66e"
    sha256 cellar: :any_skip_relocation, ventura:       "58bebfd4f1dd688286fab4c160134f5f8443fe67d7b6a48e3c7b6d219aa7c66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a96d991af8d712cbe9c1b91881f79c50019db655e1089b506dbb0f967f4325be"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comAzureazqrcmdazqr.version=#{version}"), ".cmd"

    generate_completions_from_executable(bin"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azqr -v")
    output = shell_output("#{bin}azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end