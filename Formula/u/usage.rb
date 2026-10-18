class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v7.0.2.tar.gz"
  sha256 "bff1f362d84be389fb36d1e6fe922d3c19debee86bb3093693df0afb0d73f4ce"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "63e8f34a6b5e7e5d0b0c957f581eb9d01180d4d9768dc5de291a41d68bd58c6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52415177ce235583c51f93411fce876023d19dc25eefc9838b4b27f3296c7a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9654309acbf2175f3542ab274575533e696ed4fc5e8ba3d32799bfdccd3b3f18"
    sha256 cellar: :any,                 arm64_linux:       "542091c4b78efb99cb1c0f8a712211096696febbe6ef71013f487ee69c5c0e49"
    sha256 cellar: :any,                 x86_64_linux:      "7b547fe299ad4630a214bdc8b790a9dc843e37c45f674d0fe4c849d1e572db04"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end