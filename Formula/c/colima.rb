class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https:github.comabiosoftcolimablobmainREADME.md"
  url "https:github.comabiosoftcolima.git",
      tag:      "v0.6.10",
      revision: "12c0c834633986e1c05ec2bd2d53c6cb06c89aef"
  license "MIT"
  head "https:github.comabiosoftcolima.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb7f2e5a3e49486f6dbdf77491673c42121d43a462324bf61251e8f92d3beb93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f7ffd19938fea8176677736dc4ae231a05e638f2b5415f1f262c8a039d27f21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc2f85a2182e39b9fca16711ae5b9f8c6facaabf6cb7220cc4814bdd3e89ac97"
    sha256 cellar: :any_skip_relocation, sonoma:         "89e1a354f2939998885c56ade4ae9e227e38bf4598b5196a6e854d583c5868aa"
    sha256 cellar: :any_skip_relocation, ventura:        "6e21b3787779a28dc95e2c731907d60858b5f2d8b6758ab9da3bc10256f332a9"
    sha256 cellar: :any_skip_relocation, monterey:       "8f8b5ee7f49264ad5d06cf221c3c9c762a53c66cfed55327cc891e045d26fad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12c14c7214c2dc0e9c5cf763c1bfad1fb639576e1eec2e2c02e9339ce1031782"
  end

  depends_on "go" => :build
  depends_on "lima"

  def install
    project = "github.comabiosoftcolima"
    ldflags = %W[
      -s -w
      -X #{project}config.appVersion=#{version}
      -X #{project}config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcolima"

    generate_completions_from_executable(bin"colima", "completion")
  end

  service do
    run [opt_bin"colima", "start", "-f"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env
    error_log_path var"logcolima.log"
    log_path var"logcolima.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}colima status 2>&1", 1)
  end
end