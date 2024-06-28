class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.108.0.tar.gz"
  sha256 "692a0a7fbae62d961121606922408af4b5e3182c0f34274ff142cad0423617a4"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "997d015ae3c08c1590c7454ea55c2f8a2324a2e80cca6c50b86fc2e2b878162a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "479d51badd3e7323929853c3f1803cc0505f9d086c3005c51c441cf2ea7b15f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a695d9b9167de3c803a70628a434d1a3dd612ca4ab29da2170b6c85c9987cec0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9408a62d8c2b305f4bd690275cf936a53fcce522fdb50b02665629f0293a67c1"
    sha256 cellar: :any_skip_relocation, ventura:        "a278a77bdf614557b6ffe0e2d09e85894550db44f8b6b4797f1a65957767a447"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3e37a7a63af5826f676a2fdd161534f083434db375f80836739da5bb94a882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6427accc0be006349d197229b4bde7e9499d9151c91e72147d7b0d6865bacb97"
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