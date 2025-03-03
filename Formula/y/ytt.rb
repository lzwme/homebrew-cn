class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https:carvel.devytt"
  url "https:github.comcarvel-devyttarchiverefstagsv0.51.1.tar.gz"
  sha256 "d1c4c814f702802a4acd94a5131797d09ff0ba065c746411d65237823bcc1374"
  license "Apache-2.0"
  head "https:github.comcarvel-devytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbecabaa27ac7218711e30559fcc75385168016e449de841e444a49eb169d074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbecabaa27ac7218711e30559fcc75385168016e449de841e444a49eb169d074"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbecabaa27ac7218711e30559fcc75385168016e449de841e444a49eb169d074"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae53ae8ac35bc5d016f34e097a8fba019d1236074508e63fb98924b8055f09d1"
    sha256 cellar: :any_skip_relocation, ventura:       "ae53ae8ac35bc5d016f34e097a8fba019d1236074508e63fb98924b8055f09d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6611056f1cba2cc3c19c546aa9734ec595f2133f2c070b39015d319a366e3ff4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.devyttpkgversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdytt"

    generate_completions_from_executable(bin"ytt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ytt version")

    (testpath"values.lib.yml").write <<~YAML
      #@ def func1():
      name: max
      cities:
      - SF
      - LA
      #@ end

      #@ def func2():
      name: joanna
      cities:
      - SF
      #@ end
    YAML

    (testpath"template.yml").write <<~YAML
      #! YAML library files must be named *.lib.yml
      #@ load("values.lib.yml", "func1", "func2")

      func1_key: #@ func1()
      func2_key: #@ func2()
    YAML

    assert_match <<~YAML, shell_output("#{bin}ytt -f values.lib.yml -f template.yml")
      func1_key:
        name: max
        cities:
        - SF
        - LA
    YAML
  end
end