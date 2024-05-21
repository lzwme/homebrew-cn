class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.8.tar.gz"
  sha256 "5449f181e25b3038cce5843cf31a994c05e062d3c01e2228c9ef55b28b62d6ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaedeb89b8fb7083b64a6b98b1584d98a09bbe0f5df9eb954fed2f86cbab849f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "735474e11f87fb77d97a26d8c550f188b298331d4d63a2550bc0cd8cd475b0dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6c4cea6866848c089fd1176319342d049c8eb69ee16f602f1d974ba48f1cec2"
    sha256 cellar: :any_skip_relocation, sonoma:         "70d398b7810d5d2b2f3ed8c96001a3b036491c35b3412540af6e37c20a1939d8"
    sha256 cellar: :any_skip_relocation, ventura:        "b82964e668793be2011955af4fbf033b376d66a5997150f847236f8df2a211f9"
    sha256 cellar: :any_skip_relocation, monterey:       "ba1bbabd4256dc9edf8b0f6c20374a59ee8dce34db9b1431a2feca3e32241e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec5b1366a3178c652fcd5e0b7dfc52e2bd06ebb0c1fbe061aef3732fe49cddea"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end