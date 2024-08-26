class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https:github.comabiosoftcolimablobmainREADME.md"
  url "https:github.comabiosoftcolima.git",
      tag:      "v0.7.4",
      revision: "c2595d464d81a29ebf2e1cf41786c1f05295980c"
  license "MIT"
  head "https:github.comabiosoftcolima.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "835d32026973761b6c76f03bda2eacc67ea075184c227a556c049c2cf2513d34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d26676fc36ad1ab1dd0029e21ba5313b4b749d2156e23d68b81b7fae2056d657"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a86c5a6646d7f2f7b65751ec02f186ea19f0352e04d34fd550603a029250002"
    sha256 cellar: :any_skip_relocation, sonoma:         "455f32f3437ec81cda811ec7ff77784391166c8540e54d69aeebad78886cf442"
    sha256 cellar: :any_skip_relocation, ventura:        "f6c7a133a5b0eaf81f061ab35b5a778b59571b285cf707ec571e614209e89356"
    sha256 cellar: :any_skip_relocation, monterey:       "e09aceb143417a1774c80874ac46d217fe61dd817525d56ecf82317e1f4d6859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64047f59cfe42625b8d6af58e8b27ebf192aa84d304a61a8997a1ac0f029b04f"
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