class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https:github.comMightyMoudsidekick"
  url "https:github.comMightyMoudsidekickarchiverefstagsv0.6.3.tar.gz"
  sha256 "15525dcd4cd2dca9bf109b93b6ad771ca51b7a88449d0fabf43dcd8dd3ed0bd1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45adfa0f7640f06983f46e8a56599f58d347ade6c65e273bc1bb748d5c18c467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45adfa0f7640f06983f46e8a56599f58d347ade6c65e273bc1bb748d5c18c467"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45adfa0f7640f06983f46e8a56599f58d347ade6c65e273bc1bb748d5c18c467"
    sha256 cellar: :any_skip_relocation, sonoma:        "283ed8b1d05a515100fb1a2654698ed49bd860fb43ec0606ed0dd279fa1d0781"
    sha256 cellar: :any_skip_relocation, ventura:       "283ed8b1d05a515100fb1a2654698ed49bd860fb43ec0606ed0dd279fa1d0781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "366a5fd8e25c7fe85cfece626d62ccbb273254f1d9ee3c259796bd0980c42790"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'github.commightymoudsidekickcmd.version=v#{version}'"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"sidekick", "completion")
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}sidekick deploy", 1))
  end
end