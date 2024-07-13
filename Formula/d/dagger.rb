class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.12.0",
      revision: "133917c6f9ce36d8cfdc595d9b7bd2c14cbc2c20"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8c195ba5dafcb3da104e5a3b754b26c7451d6c4dfd1c0d19a384c0d4728f3a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a56d26ea9d36afc360a516cdd56a2b814e6e60ace38b3fb38ed14bab599e6376"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "912a5cc0e8f2d5a0e2c91cf5f531e177d9a7fce899b68ade846643ebd1073a58"
    sha256 cellar: :any_skip_relocation, sonoma:         "d029532a2b34eb54d873d641a9c402f21d27c7141b933b12213acd40bb8cdc92"
    sha256 cellar: :any_skip_relocation, ventura:        "bd7c090d32068e9b5edebe9180937ff9e6b5501f7b6cf43b5b05832e9a079252"
    sha256 cellar: :any_skip_relocation, monterey:       "a639b17a23533e1401e47897b54791e4775830bba4507a57020ba6a33826d3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b1acfcdd3b2ff14b9d8cfbbf12fcfc4ab461591bf3726533acd5b981ae5077"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end