class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "6016c8464884e592e34c5aed59c6b31a56d96f76121637d8bcdb5bba1a52fa70"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f05941835c34dd6e40b9f5dae32312857c6d6746a2dd3f94387f49b63748fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78bd07ef065c3cf43fdd6b8e90aa0e009878ba80a47c939fdf4fd5d71f359a71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27df78f0f71dfbec3c2387d2a9342e0b5a4fd8f62505c315b1cfebdab3a125b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "580a60a43f0cf5b1b0bcf5069c1efbbb5b4be1b913f26b21d69e52854a8465fb"
    sha256 cellar: :any,                 arm64_linux:   "9983987cb18b3b686da019ee2c41d0732f9fa4026de49d675113f1d30813cc87"
    sha256 cellar: :any,                 x86_64_linux:  "567da1438b58119c4cf936b42d661bff415d9f21ed2c8442626d714ce2902b61"
  end

  depends_on "rust" => :build
  depends_on "usage"

  def install
    (buildpath/"ui/dist").mkpath

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end