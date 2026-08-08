class Hookdeck < Formula
  desc "Forward webhook events from Hookdeck to a local server"
  homepage "https://hookdeck.com"
  url "https://ghfast.top/https://github.com/hookdeck/hookdeck-cli/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "70a2356b906f2a5560360b1dc3eb3729041c016f1b046994ebb7c3fedfea512b"
  license "Apache-2.0"
  head "https://github.com/hookdeck/hookdeck-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8814ab773e4d43b165d33fa5799bc48a14eb0e98f5584f6d90cdc1383e65bf2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8814ab773e4d43b165d33fa5799bc48a14eb0e98f5584f6d90cdc1383e65bf2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8814ab773e4d43b165d33fa5799bc48a14eb0e98f5584f6d90cdc1383e65bf2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "77bc35d58861786594e1e4f9534b3ed6443cb34d197cf8e898b4dc1522cd8f4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ffdb37ea56f21e10651021a7341482cffa914fc0205bdf28e3d09861b8c0fbb"
    sha256 cellar: :any,                 x86_64_linux:  "aa432b598e58cc0c04046b5b0126f57cb39ea1508f50bcd96da74747d839303e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/hookdeck/hookdeck-cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hookdeck", "completion",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookdeck --version")
    assert_match "Provide a project API key", shell_output("#{bin}/hookdeck ci 2>&1", 1)
  end
end