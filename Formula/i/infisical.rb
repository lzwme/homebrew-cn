class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.7.tar.gz"
  sha256 "b789d44012c7bbb858b33f09aa8e1a02228b559f3131c24af20d186ac00ceec1"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3305224e4484bdac1149a3e2614150caa350dbed5f58d71dffce1dd8a389dc9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3305224e4484bdac1149a3e2614150caa350dbed5f58d71dffce1dd8a389dc9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3305224e4484bdac1149a3e2614150caa350dbed5f58d71dffce1dd8a389dc9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b293a64a9001af63ce1d83f686ff4cb3d9acd1832beab3e2bfcb02fe9c6f73a0"
    sha256 cellar: :any_skip_relocation, ventura:       "b293a64a9001af63ce1d83f686ff4cb3d9acd1832beab3e2bfcb02fe9c6f73a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80eb566e37e6ef7c878e7c12de8df681cc1f120f0698603bd633584c1eb5945"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end