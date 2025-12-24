class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://ghfast.top/https://github.com/Scalingo/cli/archive/refs/tags/1.41.1.tar.gz"
  sha256 "92a37e60eed5e9b08d9b5a75bc124e8d08eac584c1af302d180a5bed3301549c"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52f6a6dd1a7dc82ee310bfe0e57fea2dac9270e9a2f8d19d070ab77522e03aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f6a6dd1a7dc82ee310bfe0e57fea2dac9270e9a2f8d19d070ab77522e03aa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f6a6dd1a7dc82ee310bfe0e57fea2dac9270e9a2f8d19d070ab77522e03aa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3118ea055d30fcc2b235f69dc40b95261bf43c9fe4ec7d535841a13ca8135ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63fcb0ee5fc3c93c87dffd1297febf99e5cc26c5a8f6e568d7770e6d4fb965bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd06674b064865e949bab6d5954432a6a56af556b61294c5c65acba8135e63a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end