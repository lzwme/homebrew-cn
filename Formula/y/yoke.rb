class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.2",
      revision: "5b1c0e7d0b9407e2e0b5735120a8469eacf3ff74"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65f6e1aa9217919fe0e341021a4730e8e21660dde28e3f4418e953a53a53d660"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b3be0e88638083813bb4928ce25c3ad4d0eaffc83ceb604027da13c7fc9d4e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d2b3a365eb54cda9bc8358b7981d9a2a6d7f9285b0793ffe36a1436927a9401"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ff79e1fbba0253efa2fb42fbf4204a10d13d01eff0b103cb5a7b627e88557cd"
    sha256 cellar: :any_skip_relocation, ventura:       "750c69fec2f4005c10c64168299e59455202233cb5a44d0e1b816e83fe31ce6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6372444938c5b395ed5890093dd45dcea1d6c25c2b3b4cff8f96b2f3e5e0fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "230853977fde338fdf5a500a10058a2f46d61587b82c7d1a8743538f66b005ef"
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