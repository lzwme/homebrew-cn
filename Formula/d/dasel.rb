class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https:github.comTomWrightdasel"
  url "https:github.comTomWrightdaselarchiverefstagsv2.8.1.tar.gz"
  sha256 "ba8da9569f38e7f33453c03ac988382291a01004a96c307d52cccadb9ef7837e"
  license "MIT"
  head "https:github.comTomWrightdasel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fda15f41f7ba3f9dcf3b59430a7f807f1f4685a994868364fbf25aa1c470fba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fda15f41f7ba3f9dcf3b59430a7f807f1f4685a994868364fbf25aa1c470fba9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fda15f41f7ba3f9dcf3b59430a7f807f1f4685a994868364fbf25aa1c470fba9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bde39da341ff23150659a08e3514a08a6d1d71faf33ab2d6f53c94c93c18f68"
    sha256 cellar: :any_skip_relocation, ventura:       "3bde39da341ff23150659a08e3514a08a6d1d71faf33ab2d6f53c94c93c18f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b557e95eb7bb0822d238132e746fdc26245dcfeccbad94a007722ed8a7805d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtomwrightdaselv2internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmddasel"

    generate_completions_from_executable(bin"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}dasel --version")
  end
end