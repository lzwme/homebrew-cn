class Sloth < Formula
  desc "Prometheus SLO generator"
  homepage "https:sloth.dev"
  url "https:github.comslokslotharchiverefstagsv0.11.0.tar.gz"
  sha256 "17f7ce5ebc1ebe29391b0848616c2a9881f70cd72780605db55cfd817a8331af"
  license "Apache-2.0"
  head "https:github.comsloksloth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d0d882935b6f9e2027ee01c260823b6dda8fb286abbef291f48bbe83b173171"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af0dcf4b0c575bbce9cee6ebbb080245db9fe886bf55c1d4d77b0bd25f5acda9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b6f8e012e7b22c325124fc7187d90a97282b6ef3087162b1737a733206c512"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffec5f694bc4278fa7c8a7e1b924b2939b53356c63c1281d8219defbf393e1bb"
    sha256 cellar: :any_skip_relocation, ventura:        "d73cfeff63c6abff1c31d52b5b5bcdf2b4e7461487ed61d6d4fcc99962da1266"
    sha256 cellar: :any_skip_relocation, monterey:       "0d06c525a21876a924b2b3c72914f40031ae128ba7ded54b1ca8bd9b1f43322b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "000072a25ece31770c838e9972a227702cc26277f839c692be502a406202267e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comslokslothinternalinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdsloth"

    pkgshare.install "examples"
  end

  test do
    test_file = pkgshare"examplesgetting-started.yml"

    output = shell_output("#{bin}sloth validate -i #{test_file} 2>&1")
    assert_match "Validation succeeded", output

    output = shell_output("#{bin}sloth generate -i #{test_file} 2>&1")
    assert_match "SLO alert rules generated", output
    assert_match "Code generated by Sloth", output

    assert_match version.to_s, shell_output("#{bin}sloth version")
  end
end