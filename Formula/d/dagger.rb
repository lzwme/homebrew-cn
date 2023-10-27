class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.9.1",
      revision: "ed98d775ad923c56f130bbf5237fda0399fde1b4"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36f3db3254ec971e3354ed5e43dcc510987615c1d2570463ee64bd6ab2a68236"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "514dc239313aad69b8cbef5f9d822e658e6a39092ece706cfba5730a1d878534"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da1a251da5c96d68b2fcd922bcfd540c44c46f7c211ab757c5d3a4f14f3852b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc411db112edd7236174babfa57e422581fc3ee1a03797195815517fa0fa3986"
    sha256 cellar: :any_skip_relocation, ventura:        "e5f46c75d24430d958238472d4b99d9fdf47b9cd2f1430fea95f39e4fbbaf8c3"
    sha256 cellar: :any_skip_relocation, monterey:       "f1cbbf0dcffc625d39197253a3f75f8cdd196daa5d704fc0da88947ec17b5f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74efe70a0c8c4c44041df2d7add194bbfa9117d7018a4a8bd7c92df83ecfef8a"
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