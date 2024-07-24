class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.12.2",
      revision: "166ae1d284835470a49d4d1466f974e81bdce3e3"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "246b8602fccbad77fe8e8a103eaeadbfbbb257b307ac4e0350fae47dbcc80011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3504b696da71daf697cf39aae3423d113a9b5ddb5860cd8d9c10eabd22043369"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8995bb02903d7ca94a1f8dec59376f900f6f1ccf89e79049db379b92c6e283f"
    sha256 cellar: :any_skip_relocation, sonoma:         "633509cb1ba355ed1c202d4c2c98cd5dd7ea8dcb8a50a17d259c5ef2f23fe949"
    sha256 cellar: :any_skip_relocation, ventura:        "30ea24decede2885ce91092b53c47bdf8279beafc0ae85f708663a00e5f47478"
    sha256 cellar: :any_skip_relocation, monterey:       "31475e8ff0b8900763b0ceffdb78006751704c3523f3fd826c48b324933c8a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a41ae2ae24d570dde5e8cca2705d48cff322bdb316562ae7fea7bb78e5190b73"
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