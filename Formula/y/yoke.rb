class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.6",
      revision: "c117827132ee3791f4e3483dc0b5e338bd7bfbfa"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77311a59d346dc127bc052128379e0e8b06d316e819d001e142c4084ec5527d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32bd383903fda26b2d2a8453ec64a9993f4c783aff124d6c382127ee579ef983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bfba320b38a055ce6aa656a7be0cb3daeb26f40c48ac8172317e914f43f370c"
    sha256 cellar: :any_skip_relocation, sonoma:        "21d8feeff2d6aab5ec4a875cf322ab704e9447112aaa67f95044a7ebee591313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5338893521841c5b45e11edf4609e88886063ca8f56cff14264cad15e1149e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef5bc4038019b8379c5ec88010998d7916ca1b3f90cc7ce101ea5fb9ce49b59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end