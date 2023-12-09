class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.9.4",
      revision: "1e03605d1a04699bbba71a18fa542aec64a3a8ce"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "563c8beb510ddb857d96ca52fb267da09bb7192ab04c8058a7434d1aeed629fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5af5e192250378597063b767ab3e12d4a6028cd1b398d07c1ce878a3898505b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c4fa351b1a7f1bafc35c06f9bcc623d61ab9730a6a749943c63124f4538f47"
    sha256 cellar: :any_skip_relocation, sonoma:         "c01f69688576d95ad98b39fd6169b8c5aa1cf2a25849b2d48a4664a037801569"
    sha256 cellar: :any_skip_relocation, ventura:        "1e5c75d9ce738737701128c4433da220652a47e4a00463a0792405af4009b064"
    sha256 cellar: :any_skip_relocation, monterey:       "c5d353445eeec274fc5cff0cfd705f897eb60e656e7fd1dfbd6878e99f1e112b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b192f3b65d72b11d61daca3f8ed9150502b94839197e6270f9247fcdcf39f861"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end