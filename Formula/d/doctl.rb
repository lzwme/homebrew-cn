class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.113.0.tar.gz"
  sha256 "9a74e5d7ca65dab98afdabe74d69d3d3c71bca512ff3d5ad6039881af1b14f4c"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3f5294597ed0018569d2ff537bb2c3724bcefcf4a6758dc144651949c4aa5b79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f5294597ed0018569d2ff537bb2c3724bcefcf4a6758dc144651949c4aa5b79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f5294597ed0018569d2ff537bb2c3724bcefcf4a6758dc144651949c4aa5b79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f5294597ed0018569d2ff537bb2c3724bcefcf4a6758dc144651949c4aa5b79"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4b2cec97cd1b4bd8c66e44dfd917f1b2a2aa41e8c970636140a4eb886b76d7a"
    sha256 cellar: :any_skip_relocation, ventura:        "c4b2cec97cd1b4bd8c66e44dfd917f1b2a2aa41e8c970636140a4eb886b76d7a"
    sha256 cellar: :any_skip_relocation, monterey:       "c4b2cec97cd1b4bd8c66e44dfd917f1b2a2aa41e8c970636140a4eb886b76d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85b4c7768beebe760bbe9417a9b8cc79b8d1a15ff3647b6b9cbddc19812fbfb4"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.comdigitaloceandoctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end