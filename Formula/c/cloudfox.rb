class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https:github.comBishopFoxcloudfox"
  url "https:github.comBishopFoxcloudfoxarchiverefstagsv1.14.1.tar.gz"
  sha256 "00e41b7ecf1c6d93437ae68c91bd3542a528eec541c448020153a2bb14b0b283"
  license "MIT"
  head "https:github.comBishopFoxcloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ef9c890f73b8a7761defab8f0e50ca5f59b529fd524f96d7697c2da29ea7481"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "496372d4f2d524235d77bb904779f0efcf262c3c021fbf7c7d71b9ee6e81fef4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a14f81418ca40d5db454a22c15071ccd00152869ddf52f6e6548cfce3e236c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d8432b0d48a0f035af1c3edbd7ac543dd5389a881b33ddc868d9ffa0bd325df"
    sha256 cellar: :any_skip_relocation, ventura:        "284fb6782fd1e2791df387f223e5bc0d3ea1b3da7744509943fd6d253592781c"
    sha256 cellar: :any_skip_relocation, monterey:       "47efc6b76432b4316a66cac806105ec66162e384569309fab39b7c170da63537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d95ffdd4653fecbfb78386b2a77789e7fc7c28a56ad443072edb60a6764faf88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}cloudfox --version")
  end
end