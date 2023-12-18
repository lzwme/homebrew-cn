class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https:github.comTomWrightdasel"
  url "https:github.comTomWrightdaselarchiverefstagsv2.5.0.tar.gz"
  sha256 "0e4ec875912a3ede0b84b381b14b64293c218fb9cf1472dd085bcccd1ab097a1"
  license "MIT"
  head "https:github.comTomWrightdasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bd8b5be779104bb97fcde346900b45c17e4b56334aabfd4bfd0ff4d8439f4ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02d2deaef439e1800a03ec00f64475a085bad5f92c96fdb494b22565f871be89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65c384e12e4ff2f8a3d47e758f20e2a2045034bf24ed759544a0ed23b900f464"
    sha256 cellar: :any_skip_relocation, sonoma:         "5947c1896374fdfa734dec2c19a41e1a05b0e129dc4f46d090ff4a00eafb86e6"
    sha256 cellar: :any_skip_relocation, ventura:        "3661367e510d7c60a2191f88ddabe4a408168368468b8508cffd83bf5869f5d3"
    sha256 cellar: :any_skip_relocation, monterey:       "5d2c55d3bec0f0435423c35433881c7691cb605485d14f1d553f5beecd1edde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7a28d465821579e9c63b4fee48d331ae245241bd092366f02a06999d0245a9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.comtomwrightdaselv2internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmddasel"

    generate_completions_from_executable(bin"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}dasel --version")
  end
end