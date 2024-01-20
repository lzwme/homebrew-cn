class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.9.7",
      revision: "f838acf038b5ecbaf7f64c988ee3276c18dc7811"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db3f312b461c8cd665ba2e11f566eeae856f75fcae2eeec321090e0adc5b4760"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a76233d7d8cee9955ec6543682eeb719f3894fe41d05d9dafe49c9745c32ff2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7924524395a7ebd4dd988003e8bfa0feeb704df685a0590032b7b14c747caf45"
    sha256 cellar: :any_skip_relocation, sonoma:         "f702859ca98bc0be16f3c6422ac5edc95640c35a5d36c8805f4c4ffa6c4b7651"
    sha256 cellar: :any_skip_relocation, ventura:        "ec7df076ee55f0a7b61b217e60b836f234742c8d42523ed131b66fcb6905e63e"
    sha256 cellar: :any_skip_relocation, monterey:       "a2384aed133b8b18e376d2c9189cf02e6b2ff74cd7ff7b8bd1b6c5374aa2d9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62d36536122db91513ab24232b882542c14f0e42d46fea6fc29affe91ff3423a"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end