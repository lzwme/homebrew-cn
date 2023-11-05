class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.9.3",
      revision: "d44c734dbbbcecc75507003c07acabb16375891d"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e67b2a923bd6871d230dbd0efb6bfdcb06982397fe21669923a4365519b8a54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f255ecfd09734ceec607195534c5ad3d129e1237d0303003e7bdc353f0ee10e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d3e77dca0a06fe007f27151b77af26419c18f78726a9166c3a30493edb4d7f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "41f94a3eacb65fcb23c1fa223c4e63a4856825cf8d30fa08d59b1af6b0542dda"
    sha256 cellar: :any_skip_relocation, ventura:        "b5bb67b9ee39f1734642207c4dd080396eab263715edeef7140e2c129c926788"
    sha256 cellar: :any_skip_relocation, monterey:       "0be9deaccef5fbc27a882efb11f5a8cbeb27285fa70a4266b575aa77241bf547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "085400b0a0189dd740d1fb20d7fce76339f5023079a1209c9664f198f243d891"
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